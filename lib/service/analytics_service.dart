// ignore_for_file: constant_identifier_names

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

enum LogEventName {
  login,
  logout,
  user_save,
  follow,
  unfollow,
  block,
  unblock,

  room_create,
  room_join,
  room_quit,
  kick,
  offer,
  offer_stop,
  offer_ok,
  offer_ng,
  room_delete,
  room_search_modify,
  user_search_modify,
  room_chat,

  wait_time_add,
  wait_time_add_list,
  wait_time_delete,

  database_error,
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
