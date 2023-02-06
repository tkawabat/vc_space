import 'dart:async';

import 'model_base.dart';
import '../entity/user_entity.dart';
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

  RoomUserEntity? _getEntity(dynamic result) {
    if (result == null) return null;
    if (result is! Map<String, dynamic>) return null;
    return RoomUserEntity.fromJson(result);
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

  Future<bool> insert(int roomId, String uid, RoomUserType roomUserType) async {
    return supabase
        .from(tableName)
        .insert({
          'room_id': roomId,
          'uid': uid,
          'room_user_type': roomUserType.value,
        })
        .then((_) => true)
        .catchError(ErrorService().onError(false, 'room_user.insert'));
  }
}
