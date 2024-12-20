class RoomModel {
  final String roomId;
  final String roomName;
  final String ownerId;

  RoomModel(
      {required this.roomId, required this.roomName, required this.ownerId});

  factory RoomModel.fromFirestore(Map<String, dynamic> data) {
    return RoomModel(
      roomId: data['roomId'] ?? '',
      roomName: data['roomName'] ?? '',
      ownerId: data['ownerId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'roomId': roomId,
      'roomName': roomName,
      'ownerId': ownerId,
    };
  }
}
