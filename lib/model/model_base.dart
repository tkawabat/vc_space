import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/error_service.dart';

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

  Future<List<T>> getListById<T>(
      List<String> idList,
      T? Function(DocumentSnapshot<Map<String, dynamic>>) mapFunc,
      String errorName) {
    return collectionRef
        .where(FieldPath.documentId, whereIn: idList)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> result) =>
            result.docs.map(mapFunc).toList().whereType<T>().toList())
        .catchError(ErrorService().onError<List<T>>([], errorName));
  }
}
