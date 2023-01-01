import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vc_space/entity/room_entity.dart';

class RoomModel {
  static Future<Stream<RoomEntity>> createRoom(RoomEntity room) {
    return FirebaseFirestore.instance
        .collection('room')
        .add(room.toJson())
        .then((result) => result
            .snapshots()
            .map((snapshot) => RoomEntity.fromJson(snapshot.data()!)));
  }
}
