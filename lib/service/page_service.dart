import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

import '../provider/room_list_provider.dart';
import '../route.dart';
import 'analytics_service.dart';
import 'login_service.dart';

typedef SnackBarType = AnimatedSnackBarType;

class PageService {
  static final PageService _instance = PageService._internal();
  bool replaced = true;
  bool initialized = false;
  BuildContext? context;
  WidgetRef? ref;

  factory PageService() {
    return _instance;
  }

  PageService._internal();

  void init(BuildContext context, WidgetRef ref) {
    if (replaced) {
      this.context = context;
      this.ref = ref;
      replaced = false;
    }

    if (initialized) return;

    // 一回だけ行う処理
    ref.read(roomListProvider.notifier).getList();
    initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoginService().initializeUser(ref);
    });
  }

  bool canBack() {
    return context != null && Navigator.canPop(context!);
  }

  void back() {
    if (canBack()) Navigator.pop(context!);
  }

  void transition(
    PageNames page, {
    Map<String, String>? arguments,
    bool replace = false,
  }) {
    if (context == null) return;
    if (replace) {
      replaced = true;
      Navigator.pushReplacementNamed(context!, page.path, arguments: arguments);
    } else {
      Navigator.pushNamed(context!, page.path, arguments: arguments);
    }
  }

  void snackbar(
    String text,
    SnackBarType type,
  ) {
    if (context == null) return;

    AnimatedSnackBar.material(
      text,
      type: type,
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.bottomLeft,
      duration: const Duration(seconds: 2),
    ).show(context!);
  }

  Future<void> showConfirmDialog(
    String text,
    Function() onSubmit, [
    submitText = '決定',
    Function()? onCancel,
  ]) async {
    if (context == null) {
      logEvent(LogEventName.view_error, 'confirmDialog');
      return;
    }

    return showDialog(
        context: context!,
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
