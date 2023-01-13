import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

import 'analytics_service.dart';
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

  void back() {
    if (_context == null) return;
    Navigator.pop(_context!);
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

  Future<void> showConfirmDialog(
    String text,
    Function() onSubmit, [
    submitText = '決定',
    Function()? onCancel,
  ]) async {
    if (_context == null) {
      logEvent(LogEventName.view_error, 'confirmDialog');
      return;
    }

    return showDialog(
        context: _context!,
        barrierDismissible: true,
        builder: (_) {
          return AlertDialog(content: Text(text), actions: [
            TextButton(
                child: const Text('キャンセル'),
                onPressed: () {
                  if (onCancel != null) onCancel();
                  back();
                }),
            TextButton(
                child: Text(submitText),
                onPressed: () {
                  onSubmit();
                  back();
                }),
          ]);
        });
  }
}
