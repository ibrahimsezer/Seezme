import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'webrtc_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter WebRTC Room',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WebRTCConnection(),
    );
  }
}

class WebRTCConnection extends StatefulWidget {
  const WebRTCConnection({super.key});

  @override
  State<WebRTCConnection> createState() => _WebRTCConnectionState();
}

class _WebRTCConnectionState extends State<WebRTCConnection> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  String? _roomId;
  bool _isCaller = false;

  @override
  void initState() {
    super.initState();
    Provider.of<WebRTCState>(context, listen: false).initializeRenderers();
  }

  @override
  void dispose() {
    _peerConnection?.close();
    _localStream?.dispose();
    super.dispose();
  }

  Future<void> _createRoom() async {
    _isCaller = true;
    _peerConnection = await _createPeerConnection();

    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    final roomRef = await _firestore.collection('rooms').add({
      'offer': {'type': offer.type, 'sdp': offer.sdp}
    });
    _roomId = roomRef.id;

    setState(() {
      _roomId = roomRef.id;
    });

    roomRef.snapshots().listen((snapshot) async {
      final data = snapshot.data();
      if (_peerConnection!.getRemoteDescription() == null &&
          data != null &&
          data.containsKey('answer')) {
        final answer = RTCSessionDescription(
            data['answer']['sdp'], data['answer']['type']);
        await _peerConnection!.setRemoteDescription(answer);
      }
    });

    _collectIceCandidates(
        roomRef, _peerConnection!, 'offerCandidates', 'answerCandidates');
  }

  Future<void> _joinRoom(String roomId) async {
    final roomRef = _firestore.collection('rooms').doc(roomId);
    final roomSnapshot = await roomRef.get();

    if (!roomSnapshot.exists) {
      print("Room does not exist.");
      return;
    }

    _peerConnection = await _createPeerConnection();

    final offer = roomSnapshot.data()!['offer'];
    await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']));

    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    await roomRef.update({
      'answer': {'type': answer.type, 'sdp': answer.sdp}
    });

    _collectIceCandidates(
        roomRef, _peerConnection!, 'answerCandidates', 'offerCandidates');
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final configuration = <String, dynamic>{
      "iceServers": [
        {"url": 'stun:stun.l.google.com:19302'},
        {"url": 'stun:stun1.l.google.com:19302'},
        {"url": 'stun:stun2.l.google.com:19302'},
        {"url": 'stun:stun3.l.google.com:19302'},
        {"url": 'stun:stun4.l.google.com:19302'},
      ]
    };

    final pc = await createPeerConnection(configuration);
    _localStream = await navigator.mediaDevices
        .getUserMedia({'video': true, 'audio': true});
    Provider.of<WebRTCState>(context, listen: false).localRenderer.srcObject =
        _localStream;

    _localStream!.getTracks().forEach((track) {
      pc.addTrack(track, _localStream!);
    });

    pc.onTrack = (event) {
      if (event.track.kind == 'video' || event.track.kind == 'audio') {
        Provider.of<WebRTCState>(context, listen: false)
            .setRemoteRenderer(event.streams.first);
      }
    };

    return pc;
  }

  void _collectIceCandidates(
      DocumentReference roomRef,
      RTCPeerConnection peerConnection,
      String localCandidateCollection,
      String remoteCandidateCollection) {
    final candidatesCollection = roomRef.collection(localCandidateCollection);

    peerConnection.onIceCandidate = (event) {
      if (event.candidate != null) {
        candidatesCollection.add({
          'candidate': (event.candidate as RTCIceCandidate).candidate,
          'sdpMid': (event.candidate as RTCIceCandidate).sdpMid,
          'sdpMLineIndex': (event.candidate as RTCIceCandidate).sdpMLineIndex,
        });
      }
    };

    roomRef
        .collection(remoteCandidateCollection)
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docChanges) {
        if (doc.type == DocumentChangeType.added) {
          final data = doc.doc.data();
          if (data != null) {
            final candidate = RTCIceCandidate(
                data['candidate'], data['sdpMid'], data['sdpMLineIndex']);
            peerConnection.addCandidate(candidate);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final webRTCState = Provider.of<WebRTCState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WebRTC Video Chat Room'),
      ),
      body: Column(
        children: [
          if (_roomId == null) ...[
            ElevatedButton(
              onPressed: _createRoom,
              child: const Text("Create Room"),
            ),
            TextField(
              onSubmitted: (value) {
                _joinRoom(value);
              },
              decoration:
                  const InputDecoration(labelText: 'Enter Room ID to Join'),
            ),
          ] else
            GestureDetector(
              child: Text("Current Room ID: $_roomId"),
              onLongPress: () {
                if (_roomId != null) {
                  Clipboard.setData(ClipboardData(text: _roomId!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Room ID copied to clipboard')),
                  );
                }
              },
            ),
          Row(
            children: [
              if (_localStream != null)
                Container(
                  width: 100,
                  height: 100,
                  child: RTCVideoView(webRTCState.localRenderer, mirror: true),
                ),
              if (webRTCState.remoteRenderer.srcObject != null)
                Container(
                  width: 100,
                  height: 100,
                  child: RTCVideoView(webRTCState.remoteRenderer),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
