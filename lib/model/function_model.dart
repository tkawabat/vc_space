import 'dart:async';

import '../entity/tag_count_entity.dart';
import '../entity/user_search_entity.dart';
import '../entity/user_search_input_entity.dart';
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

  Future<List<UserSearchEntity>> searchUser(
      int page, UserSearchInputEntity searchUser) async {
    final from = page * ConstService.listStep;
    final to = from + ConstService.listStep - 1;
    final timeUtc = searchUser.time.toUtc().toIso8601String();
    return supabase
        .rpc('search_user', params: {
          'p_tags': searchUser.tags,
          'p_time': timeUtc,
        })
        .range(from, to)
        .then((result) {
          if (result == null) return [] as List<UserSearchEntity>;
          if (result is! List) return [] as List<UserSearchEntity>;
          return result.map((e) => UserSearchEntity.fromJson(e)).toList();
        })
        .catchError(ErrorService()
            .onError<List<UserSearchEntity>>([], 'Function.searchUser'));
  }
}
