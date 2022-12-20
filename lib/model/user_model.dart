import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vc_space/entity/user_entity.dart';

Stream<UserEntity> getUserSnapshots(String id) {
  return FirebaseFirestore.instance
      .collection('user')
      .doc(id)
      .snapshots()
      .map((snapshot) => UserEntity.fromJson(snapshot.data()!));
}
