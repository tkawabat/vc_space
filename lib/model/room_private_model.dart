import 'dart:async';

import 'model_base.dart';
import '../entity/room_private_entity.dart';
import '../service/error_service.dart';

class RoomPrivateModel extends ModelBase {
  static final RoomPrivateModel _instance = RoomPrivateModel._internal();
  final String tableName = 'room_private';
  final String columns = '''
      *
    ''';

  factory RoomPrivateModel() {
    return _instance;
  }

  RoomPrivateModel._internal();

  List<RoomPrivateEntity> _getEntityList(dynamic result) {
    if (result == null) return [];
    if (result is! List) return [];
    return result.map((e) => RoomPrivateEntity.fromJson(e)).toList();
  }

  // RoomPrivateEntity? _getEntity(dynamic result) {
  //   if (result == null) return null;
  //   if (result is! Map<String, dynamic>) return null;
  //   return RoomPrivateEntity.fromJson(result);
  // }

  Stream<List<Map<String, dynamic>>> getStream(int roomId) {
    return supabase
        .from(tableName)
        .stream(primaryKey: ['room_id']).eq('room_id', roomId);
  }

  Future<List<RoomPrivateEntity>> getByRoomId(int roomId) async {
    return supabase
        .from(tableName)
        .select(columns)
        .eq('room_id', roomId)
        .then(_getEntityList)
        .catchError(ErrorService()
            .onError<List<RoomPrivateEntity>>([], '$tableName.getByRoomId'));
  }

  Future<bool> update(
    RoomPrivateEntity roomPrivate, {
    List<String>? targetColumnList,
  }) async {
    var json = roomPrivate.toJson();
    json.remove('room_id');

    json = selectUpdateColumn(json, targetColumnList);

    return supabase
        .from(tableName)
        .update(json)
        .eq('room_id', roomPrivate.roomId)
        .then((_) => true)
        .catchError(ErrorService().onError(false, '$tableName.update'));
  }
}
