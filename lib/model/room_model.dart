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

  RoomEntity? _get(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = getJsonWithId(snapshot);
    if (json == null) return null;
    return RoomEntity.fromJson(json);
  }

  Future<List<RoomEntity>> getRoomList() {
    return collectionRef
        .get()
        .then((results) =>
            results.docs.map(_get).toList().whereType<RoomEntity>().toList())
        .catchError(onError<List<RoomEntity>>([], 'getRoomList'));
  }

  Future<RoomEntity?> getRoom(String id) {
    return collectionRef
        .doc(id)
        .get()
        .then(_get)
        .catchError(onError(null, 'getRoom'));
  }

  Future<void> setRoom(RoomEntity room) {
    final json = room.toJson();
    final id = json['id'];
    return collectionRef
        .doc(id)
        .set(json.remove('id'))
        .catchError(onError(null, 'setRoom'));
  }

  // Future updateRoom(RoomEntity room) {
  //   return collectionRef.doc(room.id)
  // }
}
