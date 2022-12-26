import 'package:flutter/material.dart';

import 'component/l5/main_page.dart';
import 'component/l5/plan_detail_page.dart';
import 'entity/plan_entity.dart';
import 'service/analytics_service.dart';

enum PageNames {
  home('/'),
  plan('/plan'),
  ;

  const PageNames(this.path);
  final String path;
}

Route<dynamic> generateRoute(RouteSettings setting) {
  String? name = setting.name;

  if (name == null) {
    _transactionPage(PageNames.plan.path, null);
  }

  final uri = Uri.parse(name!);
  return _transactionPage(uri.path, uri.queryParameters);
}

Route<dynamic> _transactionPage(
    String path, Map<String, String>? queryParameters) {
  Widget Function(BuildContext context) builder;

  if (path == PageNames.home.path) {
    builder = (_) => _homePageTransaction();
  } else if (path == PageNames.plan.path) {
    builder = (_) => _planPageTransaction(queryParameters);
  } else {
    builder = (_) => _homePageTransaction();
  }

  screenView(path);
  return MaterialPageRoute(
    builder: builder,
    fullscreenDialog: false,
  );
}

Widget _homePageTransaction() =>
    const MainPage(title: 'Flutter Demo Home Page');

Widget _planPageTransaction(Map<String, String>? queryParameters) {
  if (queryParameters == null) {
    return _homePageTransaction();
  }
  if (!queryParameters!.containsKey('id')) {
    return _homePageTransaction();
  }

  return PlanDetailPage(plan: createSamplePlan(queryParameters['id']!));
}
