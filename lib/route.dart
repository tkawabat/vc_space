import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'component/page/analytics_tag_page.dart';
import 'component/page/calendar_page.dart';
import 'component/page/calendar_wait_page.dart';
import 'component/page/main_page.dart';
import 'component/page/notice_page.dart';
import 'component/page/room_detail_page.dart';
import 'component/page/room_offer_page.dart';
import 'component/page/user_page.dart';
import 'component/page/maintenance_page.dart';
import 'service/analytics_service.dart';

enum PageNames {
  none(''),
  home('/'),
  user('/user'),
  room('/room'),
  roomOffer('/room/offer'),
  calendar('/calendar'),
  calendarWait('/calendar/wait'),
  analyticsTag('/analytics/tag'),
  notice('/notice'),
  ;

  const PageNames(this.path);
  final String path;
}

Route<dynamic> generateRoute(RouteSettings setting) {
  final maintenance = dotenv.get('MAINTENANCE', fallback: '');
  if (maintenance.isNotEmpty) {
    return MaterialPageRoute(
      builder: (_) => const MaintenancePage(),
      fullscreenDialog: false,
    );
  }

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
    builder = (_) => _homePageTransaction(queryParameters);
  } else if (path == PageNames.user.path) {
    builder = (_) => _userPageTransaction();
  } else if (path == PageNames.room.path) {
    builder = (_) => _roomPageTransaction(queryParameters);
  } else if (path == PageNames.roomOffer.path) {
    builder = (_) => _roomOfferPageTransaction();
  } else if (path == PageNames.calendar.path) {
    builder = (_) => _calendarPageTransaction(queryParameters);
  } else if (path == PageNames.calendarWait.path) {
    builder = (_) => _calendarWaitPageTransaction(queryParameters);
  } else if (path == PageNames.analyticsTag.path) {
    builder = (_) => _analyticsTagPageTransaction(queryParameters);
  } else if (path == PageNames.notice.path) {
    builder = (_) => _noticePageTransaction();
  } else {
    builder = (_) => _homePageTransaction(null);
  }

  screenView(path);
  return MaterialPageRoute(
    builder: builder,
    fullscreenDialog: false,
  );
}

Widget _homePageTransaction(Map<String, String>? queryParameters) {
  int? roomId;
  String? uid;
  if (queryParameters != null) {
    if (queryParameters.containsKey('roomId')) {
      roomId = int.tryParse(queryParameters['roomId']!);
    }
    if (queryParameters.containsKey('uid')) {
      uid = queryParameters['uid']!;
    }
  }
  return MainPage(roomId: roomId, uid: uid);
}

Widget _userPageTransaction() => UserPage();

Widget _roomPageTransaction(Map<String, String>? queryParameters) {
  if (queryParameters == null) {
    return _homePageTransaction(null);
  }
  if (!queryParameters.containsKey('id')) {
    return _homePageTransaction(null);
  }

  final roomId = int.tryParse(queryParameters['id']!);

  if (roomId == null) return _homePageTransaction(null);

  return RoomDetailPage(roomId: roomId);
}

Widget _roomOfferPageTransaction() => const RoomOfferPage();

Widget _calendarPageTransaction(Map<String, String>? queryParameters) {
  if (queryParameters == null) {
    return _homePageTransaction(null);
  }
  if (!queryParameters.containsKey('uid')) {
    return _homePageTransaction(null);
  }

  return CalendarPage(uid: queryParameters['uid']!);
}

Widget _calendarWaitPageTransaction(Map<String, String>? queryParameters) {
  return const CalendarWaitPage();
}

Widget _analyticsTagPageTransaction(Map<String, String>? queryParameters) {
  return const AnalyticsTagPage();
}

Widget _noticePageTransaction() => const NoticePage();
