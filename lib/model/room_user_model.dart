import 'dart:async';

import 'model_base.dart';
import '../entity/room_user_entity.dart';
import '../service/error_service.dart';

class RoomUserModel extends ModelBase {
  static final RoomUserModel _instance = RoomUserModel._internal();
  final String tableName = 'room_user';
  final String columns = '''
      *,
      user!inner (
        name,
        photo
      )
    ''';

  factory RoomUserModel() {
    return _instance;
  }

  RoomUserModel._internal();

  List<RoomUserEntity> _getEntityList(dynamic result) {
    if (result == null) return [];
    if (result is! List) return [];
    return result.map((e) => RoomUserEntity.fromJson(e)).toList();
  }

  // RoomUserEntity? _getEntity(dynamic result) {
  //   if (result == null) return null;
  //   if (result is! Map<String, dynamic>) return null;
  //   return RoomUserEntity.fromJson(result);
  // }

  Stream<List<Map<String, dynamic>>> getStream(int roomId) {
    return supabase
        .from(tableName)
        .stream(primaryKey: ['room_id']).eq('room_id', roomId);
  }

  Future<List<RoomUserEntity>> getByRoomId(int roomId) async {
    return supabase
        .from(tableName)
        .select(columns)
        .eq('room_id', roomId)
        .then(_getEntityList)
        .catchError(ErrorService()
            .onError<List<RoomUserEntity>>([], '$tableName.getByRoomId'));
  }

  Future<bool> insert(int roomId, String uid, RoomUserType roomUserType,
      String? password) async {
    return supabase
        .from(tableName)
        .insert({
          'room_id': roomId,
          'uid': uid,
          'room_user_type': roomUserType.value,
          'password': password,
        })
        .then((_) => true)
        .catchError(ErrorService().onError(false, '$tableName.insert'));
  }

  Future<bool> update(
    RoomUserEntity roomUser, {
    List<String>? targetColumnList,
  }) async {
    var json = roomUser.toJson();
    json.remove('room_id');
    json.remove('uid');
    json.remove('user');

    json = selectUpdateColumn(json, targetColumnList);

    return supabase
        .from(tableName)
        .update(json)
        .eq('room_id', roomUser.roomId)
        .eq('uid', roomUser.uid)
        .then((_) => true)
        .catchError(ErrorService().onError(false, '$tableName.update'));
  }

  Future<bool> delete(int roomId, String uid) async {
    return supabase
        .from(tableName)
        .delete()
        .eq('room_id', roomId)
        .eq('uid', uid)
        .then((_) => true)
        .catchError(ErrorService().onError(false, '$tableName.delete'));
  }
}
