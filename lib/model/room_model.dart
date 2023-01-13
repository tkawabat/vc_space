import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_base.dart';
import '../service/error_service.dart';
import '../entity/room_entity.dart';

class RoomModel extends ModelBase {
  static final RoomModel _instance = RoomModel._internal();

  factory RoomModel() {
    return _instance;
  }

  RoomModel._internal() {
    collectionRef = FirebaseFirestore.instance.collection('Room');
  }

  RoomEntity? _getEntity(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = getJsonWithId(snapshot);
    if (json == null) return null;
    return RoomEntity.fromJson(json);
  }

  Future<RoomEntity?> getRoom(String id) {
    return collectionRef
        .doc(id)
        .get()
        .then(_getEntity)
        .catchError(ErrorService().onError(null, 'getRoom'));
  }

  Future<List<RoomEntity>> getRoomList() {
    return collectionRef
        .get()
        .then((results) => results.docs
            .map(_getEntity)
            .toList()
            .whereType<RoomEntity>()
            .toList())
        .catchError(
            ErrorService().onError<List<RoomEntity>>([], 'getRoomList'));
  }

  Future<void> setRoom(RoomEntity room) {
    final json = room.toJson();
    json.remove('id');
    return collectionRef
        .doc(room.id)
        .set(json)
        .catchError(ErrorService().onError(null, 'setRoom'));
  }
  }
}
