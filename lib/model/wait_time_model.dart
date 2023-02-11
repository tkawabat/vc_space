import 'dart:async';

import 'model_base.dart';
import '../entity/wait_time_entity.dart';
import '../service/error_service.dart';

class WaitTimeModel extends ModelBase {
  static final WaitTimeModel _instance = WaitTimeModel._internal();
  final String tableName = 'wait_time';
  final String columns = '''
      *
    ''';

  factory WaitTimeModel() {
    return _instance;
  }

  WaitTimeModel._internal();

  List<WaitTimeEntity> _getEntityList(dynamic result) {
    if (result == null) return [];
    if (result is! List) return [];
    return result.map((e) => WaitTimeEntity.fromJson(e)).toList();
  }

  WaitTimeEntity? _getEntity(dynamic result) {
    if (result == null) return null;
    if (result is! Map<String, dynamic>) return null;
    return WaitTimeEntity.fromJson(result);
  }

  Future<List<WaitTimeEntity>> getListByUid(String uid) async {
    return supabase
        .from(tableName)
        .select(columns)
        .eq('uid', uid)
        .then(_getEntityList)
        .catchError(ErrorService()
            .onError<List<WaitTimeEntity>>([], '$tableName.getListByUid'));
  }

  Future<WaitTimeEntity?> insert(WaitTimeEntity waitTime) async {
    var json = waitTime.toJson();
    json.remove('wait_time_id');
    json.remove('updated_at');

    return supabase
        .from(tableName)
        .insert(json)
        .select()
        .single()
        .then(_getEntity)
        .catchError(ErrorService().onError(null, '$tableName.insert'));
  }

  Future<bool> delete(String uid, int waitTimeId) async {
    return supabase
        .from(tableName)
        .delete()
        .match({
          'uid': uid,
          'wait_time_id': waitTimeId,
        })
        .then((_) => true)
        .catchError(ErrorService().onError(false, '$tableName.delete'));
  }
}
