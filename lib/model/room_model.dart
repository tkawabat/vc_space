import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_base.dart';
import '../entity/room_user_entity.dart';
import '../entity/user_entity.dart';
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

  Future<bool> join(String roomId, UserEntity user) async {
    final documentReference = collectionRef.doc(roomId);

    return FirebaseFirestore.instance
        .runTransaction<bool>((Transaction transaction) async {
      final RoomEntity? room =
          await transaction.get(documentReference).then(_getEntity);

      if (room == null) return false;
      if (room.users.length >= room.maxNumber) return false;
      if (room.users.every((e) => e.id != user.id)) return false;

      var list = [...room.users];
      list.add(RoomUserEntity(
          id: user.id,
          image: user.id,
          roomUserType: RoomUserType.member,
          updatedAt: DateTime.now()));
      transaction.update(documentReference, {'users': list});

      return true;
    }).catchError(ErrorService().onError(false, 'enterRoom'));
  }
}
