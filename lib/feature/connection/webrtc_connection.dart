import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCConnection extends StatefulWidget {
  const WebRTCConnection({super.key});

  @override
  State<WebRTCConnection> createState() => _WebRTCConnectionState();
}

class _WebRTCConnectionState extends State<WebRTCConnection> {
  final TextEditingController _channelController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _isInCall = false;
  String? _channelId;

  @override
  void initState() {
    super.initState();
    _localRenderer.initialize();
    _remoteRenderer.initialize();
  }

  @override
  void dispose() {
    _channelController.dispose();
    _peerConnection?.close();
    _localStream?.dispose();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  Future<void> _initiateCall(String channelId) async {
    _localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });
    _localRenderer.srcObject = _localStream;

    final config = <String, dynamic>{
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };

    _peerConnection = await createPeerConnection(config);

    // Add each track from the local stream individually
    for (var track in _localStream!.getTracks()) {
      await _peerConnection!.addTrack(track, _localStream!);
    }

    _peerConnection!.onIceCandidate = (candidate) {
      if (candidate != null) {
        _firestore.collection('channels/$channelId/ice_candidates').add({
          'candidate': candidate.toMap(),
        });
      }
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.track.kind == 'video') {
        setState(() {
          _remoteRenderer.srcObject = event.streams.first;
        });
      }
    };

    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);
    await _firestore.collection('channels').doc(channelId).set({
      'offer': offer.toMap(),
    });
  }

  Future<void> _joinCall(String channelId) async {
    final channel = _firestore.collection('channels').doc(channelId);
    final data = await channel.get();

    if (!data.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Channel does not exist')),
      );
      return;
    }

    final offer = data['offer'];
    await _peerConnection!.setRemoteDescription(RTCSessionDescription(
      offer['sdp'],
      offer['type'],
    ));

    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    await channel.update({
      'answer': answer.toMap(),
    });

    // Listen for ICE candidates
    channel.collection('ice_candidates').snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        final candidate = doc['candidate'];
        _peerConnection!.addCandidate(
          RTCIceCandidate(
            candidate['candidate'],
            candidate['sdpMid'],
            candidate['sdpMLineIndex'],
          ),
        );
      }
    });
  }

  void _toggleCall() async {
    if (_isInCall) {
      await _peerConnection?.close();
      _localStream?.dispose();
      _remoteRenderer.srcObject = null;
      setState(() {
        _isInCall = false;
      });
    } else {
      final channelId = _channelController.text;
      await _initiateCall(channelId);
      setState(() {
        _isInCall = true;
        _channelId = channelId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebRTC Video Chat'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _channelController,
            decoration: const InputDecoration(
              labelText: 'Channel ID',
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                if (_localStream != null)
                  RTCVideoView(
                    _localRenderer,
                    mirror: true,
                  ),
                if (_remoteRenderer.srcObject != null)
                  RTCVideoView(
                    _remoteRenderer,
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _toggleCall,
            child: Text(_isInCall ? 'End Call' : 'Start Call'),
          ),
        ],
      ),
    );
  }
}
