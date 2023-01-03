import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vc_space/entity/room_entity.dart';
import 'package:vc_space/model/model_base.dart';

class RoomModel {
  static RoomEntity? _get(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    return RoomEntity.fromJson(snapshot.data()!);
  }

  static Future<List<RoomEntity>> getRoomList() {
    return FirebaseFirestore.instance
        .collection('room')
        .get()
        .then((results) => results.docs
            .map((snapshot) => RoomEntity.fromJson(snapshot.data()))
            .toList())
        .catchError(ModelBase.onError<List<RoomEntity>>([], 'getRoomList'));
  }

  static Future<RoomEntity?> getRoom(String id) {
    return FirebaseFirestore.instance
        .collection('room')
        .doc(id)
        .get()
        .then(_get)
        .catchError(ModelBase.onError(null, 'getRoom'));
  }

  static Future<RoomEntity?> createRoom(RoomEntity room) {
    return FirebaseFirestore.instance
        .collection('room')
        .add(room.toJson())
        .then((result) => result
            .get()
            .then(_get)
            .catchError(ModelBase.onError(null, 'createRoom')));
  }
}
