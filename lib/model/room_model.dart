import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vc_space/entity/room_entity.dart';
import 'package:vc_space/model/model_base.dart';

class RoomModel {
  // TODO snapshot使わない
  static Future<Stream<RoomEntity>> createRoom(RoomEntity room) {
    return FirebaseFirestore.instance
        .collection('room')
        .add(room.toJson())
        .then((result) => result
            .snapshots()
            .map((snapshot) => RoomEntity.fromJson(snapshot.data()!)));
  }

  static Future<List<RoomEntity>> getRoomList() {
    return FirebaseFirestore.instance
        .collection('room')
        .get()
        .then((results) => results.docs
            .map((snapshot) => RoomEntity.fromJson(snapshot.data()))
            .toList())
        .catchError(ModelBase.onError([] as List<RoomEntity>, 'getRoomList'));
  }

  static Future<RoomEntity?> getRoom(String id) {
    return FirebaseFirestore.instance
        .collection('room')
        .doc(id)
        .get()
        .then((result) {
      if (!result.exists) {
        return null;
      }
      return RoomEntity.fromJson(result.data()!);
    }).catchError(ModelBase.onError(null, 'getRoom'));
  }
}
