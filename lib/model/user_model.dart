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

  Future<bool> updateUser(UserEntity user) async {
    var json = user.toJson();
    json.remove('uid');
    json.remove('name');
    json.remove('photo');
    json.remove('discord_name');

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
}
