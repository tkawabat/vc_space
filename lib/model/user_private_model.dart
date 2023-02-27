import 'model_base.dart';
import '../service/error_service.dart';
import '../entity/user_private_entity.dart';

class UserPrivateModel extends ModelBase {
  static final UserPrivateModel _instance = UserPrivateModel._internal();
  final String tableName = 'user_private';
  final String columns = '''
      *
    ''';

  factory UserPrivateModel() {
    return _instance;
  }

  UserPrivateModel._internal();

  UserPrivateEntity? _getEntity(dynamic result) {
    if (result == null) return null;
    if (result is! Map<String, dynamic>) return null;
    return UserPrivateEntity.fromJson(result);
  }

  Future<UserPrivateEntity?> getByUid(String uid) {
    return supabase
        .from(tableName)
        .select(columns)
        .eq('uid', uid)
        .single()
        .then(_getEntity)
        .catchError(ErrorService().onError(null, '$tableName.getById'));
  }

  Future<bool> update(
    UserPrivateEntity user, {
    List<String>? targetColumnList,
  }) async {
    var json = user.toJson();
    json.remove('uid');

    json = selectUpdateColumn(json, targetColumnList);

    return supabase
        .from(tableName)
        .update(json)
        .eq('uid', user.uid)
        .then((_) => true)
        .catchError(ErrorService().onError(false, '$tableName.update'));
  }
}
