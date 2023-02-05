import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'model_base.dart';
import '../entity/chat_entity.dart';
import '../entity/user_entity.dart';
import '../entity/room_user_entity.dart';
import '../entity/room_entity.dart';
import '../service/error_service.dart';

class RoomModel extends ModelBase {
  final String tableName = 'room';
  static final RoomModel _instance = RoomModel._internal();

  factory RoomModel() {
    return _instance;
  }

  RoomModel._internal() {
    collectionRef = FirebaseFirestore.instance.collection('Room');
  }

  RoomEntity? _getEntity(dynamic result) {
    if (result == null) return null;
    if (result is! Map<String, dynamic>) return null;
    return RoomEntity.fromJson(result);
  }

  RoomEntity? _getEntityOld(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = getJsonWithId(snapshot);
    if (json == null) return null;
    return RoomEntity.fromJson(json);
  }

  Future<RoomEntity?> getRoom(String id) {
    return collectionRef
        .doc(id)
        .get()
        .then(_getEntityOld)
        .catchError(ErrorService().onError(null, 'getRoom'));
  }

  Stream<RoomEntity?> getRoomSnapshot(String id) {
    return collectionRef
        .doc(id)
        .snapshots()
        .map(_getEntityOld)
        .handleError(ErrorService().onError(null, 'getRoomSnapshot'));
  }

  Future<List<RoomEntity>> getRoomList() {
    return collectionRef
        // .where('tags', whereIn: ['a'])
        .orderBy('updatedAt', descending: true)
        .get()
        .then((results) => results.docs
            .map(_getEntityOld)
            .toList()
            .whereType<RoomEntity>()
            .toList())
        .catchError(
            ErrorService().onError<List<RoomEntity>>([], 'getRoomList'));
  }

  Future<RoomEntity?> insertRoom(RoomEntity room) async {
    var json = room.toJson();
    json.remove('room_id');

    return await supabase
        .from(tableName)
        .insert(json)
        .select()
        .single()
        .then(_getEntity)
        .catchError(ErrorService().onError(null, 'insertRoom'));
  }

  Future<bool> join(String roomId, UserEntity user) async {
    // TODO
    return true;
    // final documentReference = collectionRef.doc(roomId);

    // return FirebaseFirestore.instance
    //     .runTransaction<bool>((Transaction transaction) async {
    //   final RoomEntity? room =
    //       await transaction.get(documentReference).then(_getEntity);

    //   if (room == null) return false;
    //   if (room.users.length >= room.maxNumber) return false;
    //   if (!room.users.every((e) => e.id != user.uid)) return false;

    //   var list = [...room.users];
    //   list.add(RoomUserEntity(
    //       id: user.uid,
    //       photo: user.uid,
    //       roomUserType: RoomUserType.member,
    //       updatedAt: DateTime.now()));
    //   transaction.update(
    //       documentReference, {'users': list.map((e) => e.toJson()).toList()});

    //   return true;
    // }).catchError(ErrorService().onError(false, 'joinRoom'));
  }

  Future<void> addChat(RoomEntity room, UserEntity user, String text) async {
    // var list = [...room.chats];
    // final now = DateTime.now();
    // list.add(ChatEntity(
    //   userId: user.uid,
    //   name: user.name,
    //   photo: user.photo,
    //   text: text,
    //   updatedAt: now,
    // ));

    // list.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));

    // final diff = list.length - ConstService.chatMaxNumber;
    // if (diff > 0) list.removeRange(0, diff);

    // return collectionRef.doc(room.id).update({
    //   'chats': list.map((e) => e.toJson()).toList(),
    //   'updatedAt': now
    // }).catchError(ErrorService().onError(null, 'addChat'));
  }
}
