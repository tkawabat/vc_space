import 'package:flutter/material.dart';

import 'component/page/calendar_page.dart';
import 'component/page/main_page.dart';
import 'component/page/room_detail_page.dart';
import 'component/page/user_page.dart';
import 'service/analytics_service.dart';

enum PageNames {
  home('/'),
  room('/room'),
  user('/user'),
  calendar('/calendar'),
  ;

  const PageNames(this.path);
  final String path;
}

Route<dynamic> generateRoute(RouteSettings setting) {
  String? name = setting.name;

  if (name == null) {
    _transactionPage(PageNames.home.path, null);
  }

  final uri = Uri.parse(name!);

  Map<String, String> queryParameters = uri.queryParameters;
  if (queryParameters.isEmpty && setting.arguments is Map<String, String>) {
    queryParameters = setting.arguments as Map<String, String>;
  }

  return _transactionPage(uri.path, queryParameters);
}

Route<dynamic> _transactionPage(
    String path, Map<String, String>? queryParameters) {
  Widget Function(BuildContext context) builder;

  if (path == PageNames.home.path) {
    builder = (_) => _homePageTransaction();
  } else if (path == PageNames.user.path) {
    builder = (_) => _userPageTransaction();
  } else if (path == PageNames.room.path) {
    builder = (_) => _roomPageTransaction(queryParameters);
  } else if (path == PageNames.calendar.path) {
    builder = (_) => _calendarPageTransaction(queryParameters);
  } else {
    builder = (_) => _homePageTransaction();
  }

  screenView(path);
  return MaterialPageRoute(
    builder: builder,
    fullscreenDialog: false,
  );
}

Widget _homePageTransaction() => const MainPage();

Widget _userPageTransaction() => UserPage();

Widget _roomPageTransaction(Map<String, String>? queryParameters) {
  if (queryParameters == null) {
    return _homePageTransaction();
  }
  if (!queryParameters.containsKey('id')) {
    return _homePageTransaction();
  }

  final roomId = int.tryParse(queryParameters['id']!);

  if (roomId == null) return _homePageTransaction();

  return RoomDetailPage(roomId: roomId);
}

Widget _calendarPageTransaction(Map<String, String>? queryParameters) {
  if (queryParameters == null) {
    return _homePageTransaction();
  }
  if (!queryParameters.containsKey('userId')) {
    return _homePageTransaction();
  }

  return CalendarPage(uid: queryParameters['userId']!);
}
