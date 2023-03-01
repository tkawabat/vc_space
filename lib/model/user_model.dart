import '../service/const_service.dart';
import 'model_base.dart';
import '../service/error_service.dart';
import '../entity/user_entity.dart';

class UserModel extends ModelBase {
  static final UserModel _instance = UserModel._internal();
  final String tableName = 'user';
  final String columns = '''
      *
    ''';

  factory UserModel() {
    return _instance;
  }

  UserModel._internal();

  List<UserEntity> _getEntityList(dynamic result) {
    if (result == null) return [];
    if (result is! List) return [];
    return result.map((e) => _getEntity(e)!).toList();
  }

  UserEntity? _getEntity(dynamic result) {
    if (result == null) return null;
    if (result is! Map<String, dynamic>) return null;
    return UserEntity.fromJson(result);
  }

  Future<UserEntity?> getById(String uid) {
    return supabase
        .from(tableName)
        .select(columns)
        .eq('uid', uid)
        .single()
        .then(_getEntity)
        .catchError(ErrorService().onError(null, '$tableName.getById'));
  }

  Future<bool> update(
    UserEntity user, {
    List<String>? targetColumnList,
  }) async {
    var json = user.toJson();
    json.remove('uid');
    json.remove('name');
    json.remove('photo');
    json.remove('discord_name');

    json = selectUpdateColumn(json, targetColumnList);

    return supabase
        .from(tableName)
        .update(json)
        .eq('uid', user.uid)
        .then((_) => true)
        .catchError(ErrorService().onError(false, '$tableName.update'));
  }

  Future<UserEntity?> upsertOnView(
      String uid, String name, String photo, String discordName) async {
    return await supabase
        .from(tableName)
        .upsert({
          'uid': uid,
          'name': name,
          'photo': photo,
          'discord_name': discordName,
        })
        .select(columns)
        .single()
        .then(_getEntity)
        .catchError(ErrorService().onError(null, '$tableName.upsertOnView'));
  }

  Future<bool> follow(String followee) {
    return supabase
        .rpc('follow', params: {
          'followee': followee,
        })
        .then((_) => true)
        .catchError(ErrorService().onError(false, '$tableName.follow'));
  }

  Future<bool> unfollow(String followee) {
    return supabase
        .rpc('unfollow', params: {
          'followee': followee,
        })
        .then((_) => true)
        .catchError(ErrorService().onError(false, '$tableName.unfollow'));
  }
}
