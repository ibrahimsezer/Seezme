import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seezme/core/models/room_model.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/viewmodels/room_view_model.dart';
import 'dart:ui';

class VideoCallWidget extends StatefulWidget {
  @override
  _VideoCallWidgetState createState() => _VideoCallWidgetState();
}

class _VideoCallWidgetState extends State<VideoCallWidget> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final RoomViewModel _roomViewModel = RoomViewModel();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _roomId = "";
  TextEditingController _roomIdController = TextEditingController();
  bool _isMicMuted = false;
  bool _isCameraOff = false;
  bool _isSpeakerOn = true;
  bool _isCallStarted = false;

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _peerConnection?.close();
    super.dispose();
  }

  Future<void> _initializeRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _startVideoCall() async {
    try {
      // Initialize media stream
      _localStream = await navigator.mediaDevices.getUserMedia({
        'audio': true,
        'video': {
          'facingMode': 'user',
          'mandatory': {
            'minWidth': '640',
            'minHeight': '480',
            'minFrameRate': '30',
          },
          'optional': [],
        }
      });

      setState(() {
        _localRenderer.srcObject = _localStream;
      });

      // Enhanced WebRTC configuration with multiple STUN/TURN servers
      final configuration = {
        'iceServers': [
          {
            'urls': [
              'stun:stun1.l.google.com:19302',
              'stun:stun2.l.google.com:19302',
              'stun:stun3.l.google.com:19302',
              'stun:stun4.l.google.com:19302',
            ]
          },
          // Add your TURN server credentials here
          {
            'urls': 'turn:your-turn-server.com:3478',
            'username': 'your-username',
            'credential': 'your-password',
          }
        ],
        'iceCandidatePoolSize': 10,
        'sdpSemantics': 'unified-plan',
        'bundlePolicy': 'max-bundle',
        'rtcpMuxPolicy': 'require',
        'iceTransportPolicy': 'all', // Use 'relay' to force TURN usage
      };

      // Create peer connection with enhanced options
      _peerConnection = await createPeerConnection(configuration);

      // Add connection state monitoring
      _peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
        print('Connection state change: $state');
        if (state == RTCPeerConnectionState.RTCPeerConnectionStateFailed) {
          _handleConnectionFailure();
        }
      };

      _peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
        print('ICE Connection state change: $state');
      };

      // Add local stream to peer connection
      _localStream?.getTracks().forEach((track) {
        _peerConnection?.addTrack(track, _localStream!);
      });

      // Set up remote stream listener
      _peerConnection?.onTrack = (event) {
        if (event.track.kind == 'video') {
          setState(() {
            _remoteRenderer.srcObject = event.streams.first;
          });
        }
      };

      // Handle new call vs joining existing call
      if (_roomId.isEmpty) {
        // Starting a new call
        await _createRoom();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('New room created. Share the Room ID to invite others.'),
            action: SnackBarAction(
              label: 'Copy ID',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _roomId));
              },
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        // Joining existing call
        await _joinRoom();
      }
    } catch (e) {
      print('Error in _startVideoCall: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start video call. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _createRoom() async {
    final room = RoomModel(roomId: '', roomName: 'TestRoom', ownerId: '');
    try {
      _roomId = await _roomViewModel.createRoom(room);
      setState(() {});

      // Create offer with specific constraints
      final offerOptions = {
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true,
      };

      RTCSessionDescription offer =
          await _peerConnection!.createOffer(offerOptions);

      // Set preferred codecs (optional)
      String sdpWithPreferredCodecs = _preferH264Codec(offer.sdp!);
      offer = RTCSessionDescription(sdpWithPreferredCodecs, offer.type);

      await _peerConnection!.setLocalDescription(offer);

      // Save offer to Firestore
      final roomRef = _firestore.collection('rooms').doc(_roomId);
      await roomRef.update({
        'offer': {
          'type': offer.type,
          'sdp': offer.sdp,
        },
      });

      // Listen for remote answer
      roomRef.snapshots().listen((snapshot) async {
        if (snapshot.data() != null && snapshot.data()!['answer'] != null) {
          final answer = snapshot.data()!['answer'];
          await _peerConnection!.setRemoteDescription(
            RTCSessionDescription(answer['sdp'], answer['type']),
          );
        }
      });

      // Add ICE candidates
      _peerConnection!.onIceCandidate = (candidate) {
        roomRef.collection('callerCandidates').add({
          'candidate': candidate.toMap(),
        });
      };

      roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data();
            _peerConnection!.addCandidate(RTCIceCandidate(
              data!['candidate']['candidate'],
              data['candidate']['sdpMid'],
              data['candidate']['sdpMLineIndex'],
            ));
          }
        }
      });
    } catch (e) {
      print('Error creating room: $e');
    }
  }

  Future<void> _joinRoom() async {
    try {
      final room = await _roomViewModel.getRoom(_roomId);
      if (room == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Room not found')),
        );
        return;
      }

      final roomRef =
          FirebaseFirestore.instance.collection('rooms').doc(_roomId);

      // Listen for offer and set it as remote description
      roomRef.snapshots().listen((snapshot) async {
        if (snapshot.data() != null && snapshot.data()!['offer'] != null) {
          final offer = snapshot.data()!['offer'];
          await _peerConnection!.setRemoteDescription(
            RTCSessionDescription(offer['sdp'], offer['type']),
          );

          // Create an answer and send it back
          RTCSessionDescription answer = await _peerConnection!.createAnswer();
          await _peerConnection!.setLocalDescription(answer);

          // Save answer to Firestore
          await roomRef.update({
            'answer': {
              'type': answer.type,
              'sdp': answer.sdp,
            },
          });
        }
      });

      // Add ICE candidates
      _peerConnection!.onIceCandidate = (candidate) {
        roomRef.collection('calleeCandidates').add({
          'candidate': candidate.toMap(),
        });
      };

      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        for (var change in snapshot.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final data = change.doc.data();
            _peerConnection!.addCandidate(RTCIceCandidate(
              data!['candidate']['candidate'],
              data['candidate']['sdpMid'],
              data['candidate']['sdpMLineIndex'],
            ));
          }
        }
      });
    } catch (e) {
      print('Error joining room: $e');
    }
  }

  // Add new method to handle connection failures
  void _handleConnectionFailure() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connection failed. Retrying...'),
        duration: Duration(seconds: 2),
      ),
    );

    // Implement reconnection logic
    _restartConnection();
  }

  Future<void> _restartConnection() async {
    await _peerConnection?.close();
    _peerConnection = null;
    _startVideoCall();
  }

  // Add method to prefer H264 codec (optional)
  String _preferH264Codec(String sdp) {
    final List<String> lines = sdp.split('\n');
    final int mLineIndex =
        lines.indexWhere((line) => line.startsWith('m=video'));
    if (mLineIndex != -1) {
      final List<String> codecLines = lines
          .skipWhile((line) => !line.startsWith('a=rtpmap'))
          .takeWhile((line) => line.startsWith('a=rtpmap'))
          .toList();

      final h264Lines =
          codecLines.where((line) => line.contains('H264')).toList();

      if (h264Lines.isNotEmpty) {
        // Modify the m= line to prefer H264
        final List<String> mLine = lines[mLineIndex].split(' ');
        final h264Pts =
            h264Lines.map((line) => line.split(':')[0].substring(8)).toList();

        mLine.removeRange(3, mLine.length);
        mLine.addAll(h264Pts);
        mLine.addAll(codecLines
            .where((line) => !line.contains('H264'))
            .map((line) => line.split(':')[0].substring(8)));

        lines[mLineIndex] = mLine.join(' ');
      }
    }
    return lines.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Video Views
            _buildVideoViews(),

            // Top Controls
            _buildTopControls(),

            // Bottom Controls
            _buildBottomControls(),

            // Room ID Input (when call not started)
            if (!_isCallStarted) _buildRoomIdInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoViews() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              // Remote Video (Full Screen)
              Container(
                color: Colors.grey[900],
                child: RTCVideoView(
                  _remoteRenderer,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                ),
              ),
              // Local Video (Picture in Picture)
              Positioned(
                right: 16,
                top: 16,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Implement swap camera view
                  },
                  child: Container(
                    width: 100,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: RTCVideoView(
                        _localRenderer,
                        mirror: true,
                        objectFit:
                            RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            Column(
              children: [
                Text(
                  'Video Call',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_isCallStarted)
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _roomId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Room ID copied to clipboard'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Text(
                      'Room ID: $_roomId',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.switch_camera, color: Colors.white),
              onPressed: () {
                // TODO: Implement switch camera
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withValues(alpha: 0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              icon: _isMicMuted ? Icons.mic_off : Icons.mic,
              label: _isMicMuted ? 'Unmute' : 'Mute',
              onPressed: () {
                setState(() => _isMicMuted = !_isMicMuted);
                // TODO: Implement mute logic
              },
            ),
            _buildControlButton(
              icon: _isCameraOff ? Icons.videocam_off : Icons.videocam,
              label: _isCameraOff ? 'Start Video' : 'Stop Video',
              onPressed: () {
                setState(() => _isCameraOff = !_isCameraOff);
                // TODO: Implement camera toggle
              },
            ),
            _buildControlButton(
              icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
              label: _isSpeakerOn ? 'Speaker' : 'Earpiece',
              onPressed: () {
                setState(() => _isSpeakerOn = !_isSpeakerOn);
                // TODO: Implement speaker toggle
              },
            ),
            _buildControlButton(
              icon: Icons.call_end,
              label: 'End',
              color: Colors.red,
              onPressed: () {
                // TODO: Implement end call
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color ?? Colors.white.withValues(alpha: 0.2),
          ),
          child: IconButton(
            icon: Icon(icon),
            color: Colors.white,
            onPressed: onPressed,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildRoomIdInput() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Video Call',
                  style: defaultThemeLight.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                // New Call Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: ConstColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: Size(double.infinity, 56),
                  ),
                  onPressed: () {
                    setState(() {
                      _roomId = '';
                      _roomIdController.clear();
                      _isCallStarted = true;
                    });
                    _startVideoCall();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_call, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Start New Call',
                        style: defaultThemeLight.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'OR',
                  style: defaultThemeLight.textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 24),
                // Join Existing Call Section
                Text(
                  'Join Existing Call',
                  style: defaultThemeLight.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  style: defaultThemeLight.textTheme.bodyMedium,
                  controller: _roomIdController,
                  decoration: InputDecoration(
                    labelText: 'Enter Room ID',
                    labelStyle: defaultThemeLight.textTheme.bodyMedium,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: ConstColors.primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: ConstColors.primaryColor, width: 2),
                    ),
                    prefixIcon: Icon(Icons.meeting_room,
                        color: ConstColors.primaryColor),
                    hintText: 'Paste room ID here',
                    hintStyle: defaultThemeLight.textTheme.displayLarge,
                  ),
                  onChanged: (value) => setState(() => _roomId = value),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Colors.white,
                    foregroundColor: ConstColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side:
                          BorderSide(color: ConstColors.primaryColor, width: 2),
                    ),
                    minimumSize: Size(double.infinity, 56),
                  ),
                  onPressed: _roomId.isEmpty
                      ? null
                      : () {
                          setState(() => _isCallStarted = true);
                          _startVideoCall();
                        },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.login, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Join Call',
                        style:
                            defaultThemeLight.textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_roomId.isNotEmpty) ...[
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _roomId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Room ID copied to clipboard'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.copy,
                            size: 16, color: ConstColors.fontColor),
                        SizedBox(width: 8),
                        Text(
                          'Copy Room ID',
                          style: defaultThemeLight.textTheme.displayLarge
                              ?.copyWith(
                            color: ConstColors.fontColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
