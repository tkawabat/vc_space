import 'dart:async';

import '../entity/user_entity.dart';
import '../service/const_service.dart';
import '../service/time_service.dart';
import 'model_base.dart';
import '../entity/wait_time_entity.dart';
import '../service/error_service.dart';

class WaitTimeModel extends ModelBase {
  static final WaitTimeModel _instance = WaitTimeModel._internal();
  final String tableName = 'wait_time';
  final String columns = '''
      *,
      user!inner (
        *
      )
    ''';

  factory WaitTimeModel() {
    return _instance;
  }

  WaitTimeModel._internal();

  Map<String, dynamic> _getJson(WaitTimeEntity entity) {
    var json = entity.toJson();
    json.remove('wait_time_id');
    json.remove('updated_at');
    json.remove('user');
    return json;
  }

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
    final startTime = TimeService().today().toUtc().toIso8601String();

    return supabase
        .from(tableName)
        .select(columns)
        .eq('uid', uid)
        .gte('start_time', startTime)
        .then(_getEntityList)
        .catchError(ErrorService()
            .onError<List<WaitTimeEntity>>([], '$tableName.getListByUid'));
  }

  Future<List<WaitTimeEntity>> getListByStartTime(
    int page,
    DateTime time, {
    UserEntity? searchUser,
  }) async {
    final start = page * ConstService.listStep;
    final to = start + ConstService.listStep - 1;

    return supabase
        .from(tableName)
        .select(columns)
        .eq('wait_time_type', WaitTimeType.valid.value)
        .lte('start_time', time)
        .gte('end_time', time)
        .order('updated_at')
        .range(start, to)
        .then(_getEntityList)
        .catchError(ErrorService()
            .onError<List<WaitTimeEntity>>([], '$tableName.getListByStatTime'));
  }

  Future<WaitTimeEntity?> insert(WaitTimeEntity waitTime) async {
    final json = _getJson(waitTime);

    return supabase
        .from(tableName)
        .insert(json)
        .select(columns)
        .single()
        .then(_getEntity)
        .catchError(ErrorService().onError(null, '$tableName.insert'));
  }

  Future<List<WaitTimeEntity>> insertList(List<WaitTimeEntity> list) async {
    List<Map<String, dynamic>> jsonList = list.map((e) => _getJson(e)).toList();

    return supabase
        .from(tableName)
        .insert(jsonList)
        .select(columns)
        .then(_getEntityList)
        .catchError(ErrorService()
            .onError<List<WaitTimeEntity>>([], '$tableName.insertList'));
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
