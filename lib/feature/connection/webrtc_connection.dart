import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class WebRTCConnection extends StatefulWidget {
  const WebRTCConnection({super.key});

  @override
  _WebRTCConnectionState createState() => _WebRTCConnectionState();
}

class _WebRTCConnectionState extends State<WebRTCConnection> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
      _createOffer();
    });
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

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
    ].request();
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ],
    };

    final pc = await createPeerConnection(config);

    pc.onIceCandidate = (candidate) {
      _firestore.collection('candidates').add(candidate.toMap());
    };

    pc.onAddStream = (stream) {
      _remoteRenderer.srcObject = stream;
    };

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });

    pc.addStream(_localStream!);
    _localRenderer.srcObject = _localStream;

    return pc;
  }

  Future<void> _createOffer() async {
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    _firestore.collection('offers').add({
      'sdp': offer.sdp,
      'type': offer.type,
    });

    _firestore.collection('answers').snapshots().listen((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['type'] == 'answer') {
          final answer = RTCSessionDescription(data['sdp'], data['type']);
          _peerConnection!.setRemoteDescription(answer);
        }
      }
    });
  }

  Future<void> _createAnswer(String offerId) async {
    final offerDoc = await _firestore.collection('offers').doc(offerId).get();
    final data = offerDoc.data()!;
    final offer = RTCSessionDescription(data['sdp'], data['type']);
    await _peerConnection!.setRemoteDescription(offer);

    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    _firestore.collection('answers').add({
      'sdp': answer.sdp,
      'type': answer.type,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebRTC Voice Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(_localRenderer),
          ),
          Expanded(
            child: RTCVideoView(_remoteRenderer),
          ),
        ],
      ),
    );
  }
}
