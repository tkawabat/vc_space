import 'package:flutter/material.dart';

import 'component/page/main_page.dart';
import 'component/page/room_detail_page.dart';
import 'entity/room_entity.dart';
import 'service/analytics_service.dart';

enum PageNames {
  home('/'),
  room('/room'),
  ;

  const PageNames(this.path);
  final String path;
}

Route<dynamic> generateRoute(RouteSettings setting) {
  String? name = setting.name;

  if (name == null) {
    _transactionPage(PageNames.room.path, null);
  }

  final uri = Uri.parse(name!);
  return _transactionPage(uri.path, uri.queryParameters);
}

Route<dynamic> _transactionPage(
    String path, Map<String, String>? queryParameters) {
  Widget Function(BuildContext context) builder;

  if (path == PageNames.home.path) {
    builder = (_) => _homePageTransaction();
  } else if (path == PageNames.room.path) {
    builder = (_) => _roomPageTransaction(queryParameters);
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

Widget _roomPageTransaction(Map<String, String>? queryParameters) {
  if (queryParameters == null) {
    return _homePageTransaction();
  }
  if (!queryParameters.containsKey('id')) {
    return _homePageTransaction();
  }

  return RoomDetailPage(room: createSampleRoom(queryParameters['id']!));
}
