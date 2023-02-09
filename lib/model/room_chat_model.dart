import 'dart:async';

import 'model_base.dart';
// import '../entity/room_chat_entity.dart';
import '../entity/user_entity.dart';
import '../service/error_service.dart';

class RoomChatModel extends ModelBase {
  static final RoomChatModel _instance = RoomChatModel._internal();
  final String tableName = 'room_chat';
  final String columns = '''
      *
    ''';

  factory RoomChatModel() {
    return _instance;
  }

  RoomChatModel._internal();

  // List<RoomChatEntity> _getEntityList(dynamic result) {
  //   if (result == null) return [];
  //   if (result is! List) return [];
  //   return result.map((e) => RoomChatEntity.fromJson(e)).toList();
  // }

  // RoomChatEntity? _getEntity(dynamic result) {
  //   if (result == null) return null;
  //   if (result is! Map<String, dynamic>) return null;
  //   return RoomChatEntity.fromJson(result);
  // }

  Stream<List<Map<String, dynamic>>> getStream(int roomId) {
    return supabase
        .from(tableName)
        .stream(primaryKey: ['room_id'])
        .eq('room_id', roomId)
        .order('updated_at')
        .limit(20);
  }

  Future<bool> insert(int roomId, UserEntity user, String text) async {
    return supabase
        .from(tableName)
        .insert({
          'room_id': roomId,
          'uid': user.uid,
          'text': text,
          'name': user.name,
          'photo': user.photo,
        })
        .then((_) => true)
        .catchError(ErrorService().onError(false, '$tableName.insert'));
  }
}
