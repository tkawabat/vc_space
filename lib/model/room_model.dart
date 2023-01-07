import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vc_space/entity/room_entity.dart';
import 'package:vc_space/model/model_base.dart';

class RoomModel extends ModelBase {
  static final RoomModel _instance = RoomModel._internal();

  factory RoomModel() {
    return _instance;
  }

  RoomModel._internal() {
    collectionRef = FirebaseFirestore.instance.collection('Room');
  }

  static RoomEntity? _get(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (!snapshot.exists) {
      return null;
    }
    return RoomEntity.fromJson(snapshot.data()!);
  }

  Future<List<RoomEntity>> getRoomList() {
    return collectionRef
        .get()
        .then((results) => results.docs
            .map((snapshot) => RoomEntity.fromJson(snapshot.data()))
            .toList())
        .catchError(onError<List<RoomEntity>>([], 'getRoomList'));
  }

  Future<RoomEntity?> getRoom(String id) {
    return collectionRef
        .doc(id)
        .get()
        .then(_get)
        .catchError(onError(null, 'getRoom'));
  }

  Future<RoomEntity?> createRoom(RoomEntity room) {
    return collectionRef.add(room.toJson()).then((result) =>
        result.get().then(_get).catchError(onError(null, 'createRoom')));
  }
}
