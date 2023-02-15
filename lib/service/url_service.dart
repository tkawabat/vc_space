import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'page_service.dart';

class UrlService {
  static final UrlService _instance = UrlService._internal();

  factory UrlService() {
    return _instance;
  }

  UrlService._internal();

  FutureOr<bool> launchUri(BuildContext context, String url) async {
    if (await canLaunchUrlString(url)) {
      return launchUrlString(url);
    } else {
      PageService().snackbar('URLが開けませんでした。', SnackBarType.error);
      return false;
    }
  }
}
