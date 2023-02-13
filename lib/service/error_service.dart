import 'package:flutter/material.dart';

import 'analytics_service.dart';

class ErrorService {
  static final ErrorService _instance = ErrorService._internal();

  factory ErrorService() {
    return _instance;
  }

  ErrorService._internal();

  T Function(dynamic error) onError<T>(
    T returnValue,
    String contentType, {
    void Function()? onError,
  }) {
    return (error) {
      if (onError != null) onError();
      debugPrint(error.toString());
      logEvent(LogEventName.database_error, contentType);
      throw Exception;
      // TODO 問題なければreturnValueを消す
      // return returnValue
    };
  }
}
