import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_base.dart';
import '../entity/user_entity.dart';

class UserModel extends ModelBase {
  static final UserModel _instance = UserModel._internal();

  factory UserModel() {
    return _instance;
  }

  UserModel._internal() {
    collectionRef = FirebaseFirestore.instance.collection('User');
  }

  UserEntity? _get(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final json = getJsonWithId(snapshot);
    if (json == null) return null;
    return UserEntity.fromJson(json);
  }

  Future<UserEntity?> getUser(String id) {
    return collectionRef
        .doc(id)
        .get()
        .then(_get)
        .catchError(onError(null, 'getUser'));
  }
}
