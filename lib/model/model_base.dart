import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/analytics_service.dart';

class ModelBase {
  late CollectionReference<Map<String, dynamic>> collectionRef;

  T Function(dynamic error) onError<T>(T returnValue, String contentType) {
    return (error) {
      debugPrint(error.toString());
      logEvent(LogEventName.firestore_error, contentType);
      return returnValue;
    };
  }
}
