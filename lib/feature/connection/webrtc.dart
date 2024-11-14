import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallScreen extends StatefulWidget {
  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  final _firestore = FirebaseFirestore.instance;

  TextEditingController _callIdController = TextEditingController();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  String callDocId = "--";
  List<Map<String, dynamic>> _gatheredCandidates = [];

  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> startCall() async {
    callDocId = _firestore.collection('calls').doc().id;
    await _initializePeerConnection();
    await _createOffer();
  }

  Future<void> _initializePeerConnection() async {
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };
    _peerConnection = await createPeerConnection(config);

    _localStream = await navigator.mediaDevices.getUserMedia({
      'video': true,
      'audio': true,
    });
    _localRenderer.srcObject = _localStream;

    _localStream!.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) async {
      await _firestore.collection('calls').doc(callDocId).update({
        'callerCandidates': FieldValue.arrayUnion([
          {
            'candidate': candidate.candidate,
            'sdpMid': candidate.sdpMid,
            'sdpMLineIndex': candidate.sdpMLineIndex
          }
        ])
      });
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        setState(() {
          _remoteRenderer.srcObject = event.streams[0];
        });
      }
    };
  }

  Future<void> _createOffer() async {
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    await _firestore.collection('calls').doc(callDocId).set({
      'callerSDP': offer.sdp,
      'callerCandidates': _gatheredCandidates,
    });
  }

  // Future<void> _addIceCandidateToFirestore(RTCIceCandidate candidate) async {
  //   await _firestore.collection('calls').doc(callDocId).update({
  //     'callerCandidates': FieldValue.arrayUnion([
  //       {
  //         'candidate': candidate.candidate,
  //         'sdpMid': candidate.sdpMid,
  //         'sdpMLineIndex': candidate.sdpMLineIndex
  //       }
  //     ])
  //   });
  // }

  Future<void> joinCall(String callDocId) async {
    final doc = await _firestore.collection('calls').doc(callDocId).get();
    if (doc.exists) {
      final offer = doc['callerSDP'];
      await _initializePeerConnection();
      await _setRemoteDescription(offer);
      await _createAnswer();

      List<dynamic> callerCandidates = doc['callerCandidates'];
      for (var candidate in callerCandidates) {
        _peerConnection!.addCandidate(RTCIceCandidate(
          candidate['candidate'],
          candidate['sdpMid'],
          candidate['sdpMLineIndex'],
        ));
      }
    }
  }

  Future<void> _setRemoteDescription(String offer) async {
    await _peerConnection!
        .setRemoteDescription(RTCSessionDescription(offer, 'offer'));
  }

  Future<void> _createAnswer() async {
    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    await _firestore.collection('calls').doc(callDocId).update({
      'calleeSDP': answer.sdp,
      'calleeCandidates': _gatheredCandidates,
    });
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _localStream?.dispose();
    _peerConnection?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebRTC Video Call')),
      body: Column(
        children: [
          TextButton(
              onPressed: () => startCall(), child: Text('Start New Call')),
          GestureDetector(
              onDoubleTap: () {
                Clipboard.setData(ClipboardData(text: callDocId));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Call ID copied to clipboard')),
                );
              },
              child: Text('Call ID: $callDocId')),
          TextField(
            controller: _callIdController,
            onSubmitted: (value) {
              callDocId = _callIdController.text;
              joinCall(callDocId);
            },
          ),
          Container(
              width: 150, height: 150, child: RTCVideoView(_localRenderer)),
          SizedBox(height: 20),
          Container(
              width: 150,
              height: 150,
              child: RTCVideoView(
                _remoteRenderer,
              )),
        ],
      ),
    );
  }
}
