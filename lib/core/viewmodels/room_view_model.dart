import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seezme/core/models/room_model.dart';

class RoomViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createRoom(RoomModel room) async {
    try {
      final roomRef = _firestore.collection('rooms').doc();
      room = RoomModel(roomId: roomRef.id, roomName: room.roomName);
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
