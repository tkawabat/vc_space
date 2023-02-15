import 'dart:async';
import 'package:flutter/material.dart';

import '../entity/room_user_entity.dart';
import '../entity/room_entity.dart';
import '../service/const_service.dart';
import '../service/const_system.dart';
import '../service/error_service.dart';
import 'model_base.dart';

class RoomModel extends ModelBase {
  static final RoomModel _instance = RoomModel._internal();
  final String tableName = 'room';
  final String columns = '''
      *,
      room_user!inner (
        *,
        user!inner (
          name,
          photo,
          discord_name
        )
      )
    ''';

  factory RoomModel() {
    return _instance;
  }

  RoomModel._internal();

  void hoge() async {
    // TODO
    supabase
        .rpc('insert_room_owner')

        // supabase
        //     .from('room_user')
        //     .update({'uid': '5fdcbb10-31fd-4e9a-9db6-a2541a96d43b'})
        //     .eq('room_id', 1)
        //     // .eq('uid', '5fdcbb10-31fd-4e9a-9db6-a2541a96d43b')
        //     .eq('uid', 'b9c4b219-5bf9-4b68-b983-7b648f3a5758')
        .then((_) => debugPrint('success'))
        .catchError(ErrorService().onError(null, 'hoge'));
  }

  String _getStartTimeLimit() {
    return DateTime.now()
        .add(const Duration(hours: ConstService.roomStartTimeLimitHours))
        .toUtc()
        .toIso8601String();
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

  Future<RoomEntity?> getById(int roomId) {
    return supabase
        .from(tableName)
        .select(columns)
        .eq('room_id', roomId)
        .lt('room_user.room_user_type', RoomUserType.kick.value)
        .single()
        .then(_getEntity)
        .catchError(ErrorService().onError(null, '$tableName.getById'));
  }

  Stream<List<Map<String, dynamic>>> getStream(int roomId) {
    return supabase
        .from(tableName)
        .stream(primaryKey: ['room_id']).eq('room_id', roomId);
  }

  Future<List<RoomEntity>> getList(int start) async {
    return supabase
        .from(tableName)
        .select(columns)
        .lt('room_user.room_user_type', RoomUserType.kick.value)
        .gte('start_time', _getStartTimeLimit())
        .order('start_time', ascending: true)
        .range(start, start + ConstService.roomListStep)
        .then(_getEntityList)
        .catchError(
            ErrorService().onError<List<RoomEntity>>([], '$tableName.getList'));
  }

  Future<List<RoomEntity>> getJoinList(String uid) async {
    return supabase
        .from(tableName)
        .select('$columns, check:room_user!inner (uid)')
        .in_('check.uid', [uid])
        .lt('check.room_user_type', RoomUserType.kick.value)
        .lt('room_user.room_user_type', RoomUserType.kick.value)
        .gte('start_time', _getStartTimeLimit())
        .order('start_time', ascending: true)
        .then(_getEntityList)
        .catchError(ErrorService()
            .onError<List<RoomEntity>>([], '$tableName.getJoinList'));
  }

  Future<int> insert(RoomEntity room) async {
    var json = room.toJson();
    json.remove('room_id');
    json.remove('room_user');
    json['password'] = encodePassword(json['password']);

    return supabase
        .from(tableName)
        .insert(json)
        .select('room_id')
        .single()
        .then((value) {
      return value['room_id'] as int;
    }).catchError(ErrorService()
            .onError(ConstSystem.idNotFound, '$tableName.insert'));
  }

  Future<bool> update(
    RoomEntity room, {
    List<String>? targetColumnList,
  }) async {
    var json = room.toJson();
    json.remove('room_id');
    json.remove('owner');
    json.remove('room_user');

    if (targetColumnList != null) {
      for (var key in json.keys) {
        if (targetColumnList.contains(key)) continue;
        json.remove(key);
      }
    }

    return supabase
        .from(tableName)
        .update(json)
        .eq('room_id', room.roomId)
        .then((_) => true)
        .catchError(ErrorService().onError(false, '$tableName.update'));
  }
}
