import 'package:flutter/material.dart';

import 'analytics_service.dart';

class ErrorService {
  static final ErrorService _instance = ErrorService._internal();

  factory ErrorService() {
    return _instance;
  }

  ErrorService._internal();

  T Function(dynamic error) onError<T>(T returnValue, String contentType) {
    return (error) {
      debugPrint(error.toString());
      logEvent(LogEventName.firestore_error, contentType);
      return returnValue;
    };
  }
}
