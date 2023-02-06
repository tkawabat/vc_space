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
  static final RoomModel _instance = RoomModel._internal();
  final String tableName = 'room';
  final String columns = '''
      *,
      user:owner (
        name,
        photo
      )
    ''';

  factory RoomModel() {
    return _instance;
  }

  RoomModel._internal() {
    collectionRef = FirebaseFirestore.instance.collection('Room');
  }

  void hoge() async {
    supabase
        .from('room_user')
        .update({'uid': '5fdcbb10-31fd-4e9a-9db6-a2541a96d43b'})
        .eq('room_id', 1)
        // .eq('uid', '5fdcbb10-31fd-4e9a-9db6-a2541a96d43b')
        .eq('uid', 'b9c4b219-5bf9-4b68-b983-7b648f3a5758')
        .then((_) => debugPrint('success'))
        .catchError(ErrorService().onError(null, 'hoge'));
  }

  List<RoomEntity> _getEntityList(dynamic result) {
    if (result == null) return [];
    if (result is! List) return [];
    return result.map((e) => RoomEntity.fromJson(e)).toList();
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

  Future<List<RoomEntity>> getRoomList() async {
    return supabase
        .from(tableName)
        .select(columns)
        .then(_getEntityList)
        .catchError(
            ErrorService().onError<List<RoomEntity>>([], 'getRoomList'));
  }

  Future<RoomEntity?> insert(RoomEntity room) async {
    var json = room.toJson();
    json.remove('room_id');
    json.remove('user');
    json['password'] = encodePassword(json['password']);

    return supabase
        .from(tableName)
        .insert(json)
        .select(columns)
        .single()
        .then(_getEntity)
        .catchError(ErrorService().onError(null, 'room.insert'));
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
