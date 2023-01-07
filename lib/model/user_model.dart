import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_base.dart';
import '../entity/user_entity.dart';

class UserModel extends ModelBase {
  static final UserModel _instance = UserModel._internal();

  factory UserModel() {
    return _instance;
  }

  UserModel._internal() {
    collectionRef = FirebaseFirestore.instance.collection('room');
  }

  Future<UserEntity?> getUser(String id) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .get()
        .then((ref) {
      if (!ref.exists) {
        return null;
      }
      return UserEntity.fromJson(ref.data()!);
    }).catchError(onError(null, 'getUser'));
  }
}
