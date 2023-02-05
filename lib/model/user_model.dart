import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_base.dart';
import '../service/error_service.dart';
import '../entity/user_entity.dart';

class UserModel extends ModelBase {
  final String tableName = 'user';
  static final UserModel _instance = UserModel._internal();

  factory UserModel() {
    return _instance;
  }

  UserModel._internal() {
    collectionRef = FirebaseFirestore.instance.collection('User');
  }

  UserEntity? _getEntity(dynamic result) {
    if (result == null) return null;
    if (result is! Map<String, dynamic>) return null;
    return UserEntity.fromJson(result);
  }

  UserEntity? _getEntityOld(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = getJsonWithId(snapshot);
    if (json == null) return null;
    return UserEntity.fromJson(json);
  }

  Future<UserEntity?> getUser(String id) {
    return collectionRef
        .doc(id)
        .get()
        .then(_getEntityOld)
        .catchError(ErrorService().onError(null, 'getUser'));
  }

  Future<List<UserEntity>> getUserList(List<String> idList) {
    return getListById<UserEntity>(idList, _getEntityOld, 'getUserList');
  }

  Future<void> updateUser(UserEntity user) async {
    // final documentReference = collectionRef.doc(user.id);
    // return documentReference
    //     .set(user.toJson())
    //     .catchError(ErrorService().onError(false, 'updateUser'));
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
        .select()
        .single()
        .then(_getEntity)
        .catchError(ErrorService().onError(null, 'upsertOnView'));
  }
}
