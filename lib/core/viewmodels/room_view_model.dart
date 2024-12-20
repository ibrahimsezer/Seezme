import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seezme/core/models/room_model.dart';

class RoomViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> createRoom(RoomModel room) async {
    try {
      final roomRef = _firestore.collection('rooms').doc();
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }
      room = RoomModel(
          roomId: roomRef.id, roomName: room.roomName, ownerId: user.uid);
      await roomRef.set(room.toFirestore());
      return roomRef.id;
    } catch (e) {
      print('Error creating room: $e');
      rethrow;
    }
  }

  Future<RoomModel?> getRoom(String roomId) async {
    try {
      final roomRef = _firestore.collection('rooms').doc(roomId);
      final snapshot = await roomRef.get();
      if (snapshot.exists) {
        return RoomModel.fromFirestore(snapshot.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting room: $e');
      rethrow;
    }
  }
}
