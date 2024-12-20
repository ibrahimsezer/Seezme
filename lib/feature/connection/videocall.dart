import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seezme/core/models/room_model.dart';
import 'package:seezme/core/utility/constans/constants.dart';
import 'package:seezme/core/viewmodels/room_view_model.dart';

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
    // Create local media stream
    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': {'facingMode': 'user'}
    });

    setState(() {
      _localRenderer.srcObject = _localStream;
    });
    // Configure STUN servers
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };

    // Create peer connection
    _peerConnection = await createPeerConnection(configuration);

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

    // Add signaling logic
    if (_roomId.isEmpty) {
      await _createRoom();
    } else {
      await _joinRoom();
    }
  }

  Future<void> _createRoom() async {
    final room = RoomModel(roomId: '', roomName: 'TestRoom', ownerId: '');
    try {
      _roomId = await _roomViewModel.createRoom(room);
      setState(() {});
      // Create offer
      RTCSessionDescription offer = await _peerConnection!.createOffer();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Call'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: 200,
            height: 100,
            child: TextField(
              controller: _roomIdController,
              style: defaultThemeLight.textTheme.bodySmall,
              decoration: InputDecoration(
                labelText: 'Enter Room ID',
              ),
              onChanged: (value) {
                setState(() {
                  _roomId = value;
                });
              },
            ),
          ),
          GestureDetector(
            onDoubleTap: () {
              Clipboard.setData(ClipboardData(text: _roomId));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Room ID copied to clipboard')),
              );
            },
            child: Text(
              "Current RoomId: $_roomId",
              style: TextStyle(color: ConstColors.whiteColor),
            ),
          ),
          Expanded(
            child: RTCVideoView(_localRenderer, mirror: true),
          ),
          Expanded(
            child: RTCVideoView(_remoteRenderer),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _startVideoCall();
        },
        child: Icon(Icons.call),
      ),
    );
  }
}
