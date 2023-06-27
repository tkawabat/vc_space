import 'dart:async';

import '../entity/tag_count_entity.dart';
import '../entity/user_entity.dart';
import '../service/const_service.dart';
import '../service/error_service.dart';
import 'model_base.dart';

// 特殊な関数を呼び出すためのモデル
class FunctionModel extends ModelBase {
  static final FunctionModel _instance = FunctionModel._internal();

  factory FunctionModel() {
    return _instance;
  }

  FunctionModel._internal();

  // 今は使っていない
  Future<List<TagCountEntity>> selectTagCount(
    String tag,
    DateTime start,
    DateTime end,
  ) async {
    final startTime = start.toUtc().toIso8601String();
    final endTime = end.toUtc().toIso8601String();
    return supabase.rpc('select_tag_count', params: {
      'tag': tag,
      'p_start_time': startTime,
      'p_end_time': endTime,
    }).then((result) {
      if (result == null) return [] as List<TagCountEntity>;
      if (result is! List) return [] as List<TagCountEntity>;
      return result.map((e) => TagCountEntity.fromJson(e)).toList();
    }).catchError(ErrorService()
        .onError<List<TagCountEntity>>([], 'Function.selectTagCount'));
  }

  Future<List<TagCountEntity>> selectWaitTimeCount(
    List<String> tags,
    DateTime start,
    DateTime end,
  ) async {
    final startTime = start.toUtc().toIso8601String();
    final endTime = end.toUtc().toIso8601String();
    return supabase.rpc('select_wait_time_count', params: {
      'p_tags': tags,
      'p_start_time': startTime,
      'p_end_time': endTime,
    }).then((result) {
      if (result == null) return [] as List<TagCountEntity>;
      if (result is! List) return [] as List<TagCountEntity>;
      return result.map((e) => TagCountEntity.fromJson(e)).toList();
    }).catchError(ErrorService()
        .onError<List<TagCountEntity>>([], 'Function.selectWaitTimeCount'));
  }

  // follow一覧を取得
  Future<List<UserEntity>> getFollows(int page, String uid) {
    final start = page * ConstService.listStep;
    final to = start + ConstService.listStep - 1;

    return supabase
        .rpc('get_follows', params: {
          'p_uid': uid,
        })
        .range(start, to)
        .then((result) {
          if (result == null) return [] as List<UserEntity>;
          return result
              .map<UserEntity>((e) => UserEntity.fromJson(e['user_data']))
              .toList() as List<UserEntity>;
        })
        .catchError(ErrorService()
            .onError<List<UserEntity>>([], 'Function.getFollower'));
  }

  // follower一覧を取得
  Future<List<UserEntity>> getFollowers(int page, String uid) {
    final start = page * ConstService.listStep;
    final to = start + ConstService.listStep - 1;

    return supabase
        .rpc('get_followers', params: {
          'p_uid': uid,
        })
        .range(start, to)
        .then((result) {
          if (result == null) return [] as List<UserEntity>;
          return result
              .map<UserEntity>((e) => UserEntity.fromJson(e['user_data']))
              .toList() as List<UserEntity>;
        })
        .catchError(ErrorService()
            .onError<List<UserEntity>>([], 'Function.getFollowee'));
  }
}
