import 'package:cloud_firestore/cloud_firestore.dart';

import 'model_base.dart';
import '../entity/user_entity.dart';

class UserModel {
  static Future<UserEntity?> getUser(String id) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .get()
        .then((ref) {
      if (!ref.exists) {
        return null;
      }
      return UserEntity.fromJson(ref.data()!);
    }).catchError(ModelBase.onError(null, 'getUser'));
  }
}
