// ignore_for_file: constant_identifier_names

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

enum LogEventName {
  create_room,
  search_room,
  login,
  sign_up,
  modify_user,
  search_user,
  firestore_error,
  view_error,
}

Future screenView(String screenName) async {
  debugPrint("screenView: $screenName");

  return await FirebaseAnalytics.instance.logEvent(
    name: 'screen_view',
    parameters: {
      'firebase_screen': screenName,
    },
  );
}

Future logEvent(LogEventName logName, String contentType,
    [String? itemId]) async {
  itemId = itemId ?? '';

  debugPrint(
      "logName: ${logName.name}, contentType: $contentType, itemId: $itemId");

  return await FirebaseAnalytics.instance.logEvent(
    name: logName.name,
    parameters: {
      "content_type": contentType,
      "item_id": itemId,
    },
  );
}
