import 'package:cloud_firestore/cloud_firestore.dart';

class ModelBase {
  late CollectionReference<Map<String, dynamic>> collectionRef;

  Map<String, dynamic>? getJsonWithId(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    if (!snapshot.exists) {
      return null;
    }

    final json = snapshot.data()!;
    json['id'] = snapshot.id;
    return json;
  }

  String getNewId() {
    return collectionRef.doc().id;
  }
}
