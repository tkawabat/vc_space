import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

import 'login_service.dart';

typedef SnackBarType = AnimatedSnackBarType;

class PageService {
  static final PageService _instance = PageService._internal();
  bool initialized = false;
  BuildContext? _context;

  factory PageService() {
    return _instance;
  }

  PageService._internal();

  void init(BuildContext context, WidgetRef ref) {
    // 毎回だけ行う処理
    _context = context;

    if (initialized) return;

    // 一回だけ行う処理
    listenFirebaseAuth(ref);

    initialized = true;
  }

  void snackbar(
    String text,
    SnackBarType type,
  ) {
    if (_context == null) return;

    AnimatedSnackBar.material(
      text,
      type: type,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.bottomLeft,
      duration: const Duration(seconds: 2),
    ).show(_context!);
  }
}
