import 'dart:async';

import 'package:url_launcher/url_launcher_string.dart';

import 'page_service.dart';

class UrlService {
  static final UrlService _instance = UrlService._internal();

  factory UrlService() {
    return _instance;
  }

  UrlService._internal();

  Future<bool> canLaunchUrl(String url) async {
    return canLaunchUrlString(url);
  }

  Future<bool> launchUri(String url) async {
    if (await canLaunchUrl(url)) {
      return launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      PageService().snackbar('URLが開けませんでした。', SnackBarType.error);
      return false;
    }
  }
}
