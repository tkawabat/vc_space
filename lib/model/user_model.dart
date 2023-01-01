import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../entity/user_entity.dart';
import '../service/analytics_service.dart';

class UserModel {
  static T Function(dynamic error) onError<T>(
      T returnValue, String contentType) {
    return (error) {
      debugPrint(error.toString());
      logEvent(LogEventName.firestore_error, contentType);
      return returnValue;
    };
  }

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
    }).catchError(onError(null, 'getUser'));
  }
}
