class RoomModel {
  final String roomId;
  final String roomName;

  RoomModel({required this.roomId, required this.roomName});

  factory RoomModel.fromFirestore(Map<String, dynamic> data) {
    return RoomModel(
      roomId: data['roomId'] ?? '',
      roomName: data['roomName'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'roomId': roomId,
      'roomName': roomName,
    };
  }
}
