import 'package:flutter/material.dart';

import '../service/analytics_service.dart';

class ModelBase {
  static T Function(dynamic error) onError<T>(
      T returnValue, String contentType) {
    return (error) {
      debugPrint(error.toString());
      logEvent(LogEventName.firestore_error, contentType);
      return returnValue;
    };
  }
}
