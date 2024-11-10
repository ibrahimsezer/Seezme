// video_chat.dart
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoChatScreen extends StatefulWidget {
  final String channelId;

  VideoChatScreen({required this.channelId});

  @override
  _VideoChatScreenState createState() => _VideoChatScreenState();
}

class _VideoChatScreenState extends State<VideoChatScreen> {
  RTCPeerConnection? _peerConnection;
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
    _createPeerConnection();
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
    await _startLocalStream();
  }

  Future<void> _createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'}
      ]
    };
    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onIceCandidate = (candidate) {
      FirebaseFirestore.instance
          .collection('channels')
          .doc(widget.channelId)
          .collection('candidates')
          .add({
        'candidate': candidate.candidate,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'sdpMid': candidate.sdpMid,
      });
    };

    _peerConnection!.onAddStream = (stream) {
      setState(() {
        _remoteRenderer.srcObject = stream;
      });
    };

    addIceCandidates(widget.channelId);
  }

  Future<void> _startLocalStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': {'facingMode': 'user'},
    };
    final stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    _peerConnection!.addStream(stream);
    setState(() {
      _localRenderer.srcObject = stream;
    });
  }

  Future<void> createOffer() async {
    var description = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(description);

    FirebaseFirestore.instance
        .collection('channels')
        .doc(widget.channelId)
        .collection('offers')
        .add({
      'sdp': description.sdp,
      'type': description.type,
    });
  }

  Future<void> createAnswer(Map<String, dynamic> offer) async {
    await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']));
    var answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    FirebaseFirestore.instance
        .collection('channels')
        .doc(widget.channelId)
        .collection('answers')
        .add({
      'sdp': answer.sdp,
      'type': answer.type,
    });
  }

  Future<void> addIceCandidates(String channelId) async {
    FirebaseFirestore.instance
        .collection('channels')
        .doc(channelId)
        .collection('candidates')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        var candidate = doc.data();
        _peerConnection!.addCandidate(RTCIceCandidate(candidate['candidate'],
            candidate['sdpMid'], candidate['sdpMLineIndex']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(_remoteRenderer),
          ),
          Expanded(
            child: RTCVideoView(_localRenderer, mirror: true),
          ),
          ElevatedButton(
            onPressed: () => createOffer(),
            child: Text("Create Offer"),
          ),
        ],
      ),
    );
  }
}
