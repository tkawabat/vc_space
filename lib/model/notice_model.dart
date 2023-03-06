import 'dart:async';

import '../service/const_service.dart';
import 'model_base.dart';
import '../entity/notice_entity.dart';
import '../service/error_service.dart';

class NoticeModel extends ModelBase {
  static final NoticeModel _instance = NoticeModel._internal();
  final String tableName = 'notice';
  // final String columns = '''
  //     *,
  //     user!notice_id_user_fkey (
  //       name,
  //       photo,
  //       discord_name
  //     ),
  //     room!inner (
  //       *,
  //       room_user!inner (
  //         *,
  //         user!inner (
  //           name,
  //           photo,
  //           discord_name
  //         )
  //       )
  //     )
  //   ''';

  factory NoticeModel() {
    return _instance;
  }

  NoticeModel._internal();

  List<NoticeEntity> _getEntityList(dynamic result) {
    if (result == null) return [];
    if (result is! List) return [];
    return result.map((e) => NoticeEntity.fromJson(e)).toList();
  }

  // RoomChatEntity? _getEntity(dynamic result) {
  //   if (result == null) return null;
  //   if (result is! Map<String, dynamic>) return null;
  //   return RoomChatEntity.fromJson(result);
  // }

  Future<List<NoticeEntity>> getList(int page, String uid) async {
    final start = page * ConstService.listStep;
    final to = start + ConstService.listStep - 1;

    var query = supabase
        .from('v_notice')
        .select('*')
        .eq('uid', uid)
        .order('created_at')
        .range(start, to)
        .then(_getEntityList)
        .catchError(ErrorService()
            .onError<List<NoticeEntity>>([], '$tableName.getList'));

    return query;
  }

  Stream<List<Map<String, dynamic>>> getStream(String uid) {
    return supabase
        .from(tableName)
        .stream(primaryKey: ['uid'])
        .eq('uid', uid)
        .order('updated_at')
        .limit(10);
  }
}
