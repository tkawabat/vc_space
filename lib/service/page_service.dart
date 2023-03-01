import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import '../component/dialog/schedule_create_dialog.dart';
import '../provider/login_user_provider.dart';
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
    initialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoginService().initializeUser(ref);

      html.window.history.pushState(null, '', '#/');
      FlutterNativeSplash.remove();
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
    bool push = false,
  }) {
    if (context == null) return;
    if (push) {
      Navigator.pushNamed(context!, page.path, arguments: arguments);
    } else {
      replaced = true; // context, refをPageServiceに再設定するようにする
      while (Navigator.canPop(context!)) {
        Navigator.pop(context!);
      }
      Navigator.pushReplacementNamed(context!, page.path, arguments: arguments);
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
      duration: const Duration(seconds: 3),
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

  void transitionHome(PageNames current) {
    if (current == PageNames.home) return;
    PageService().transition(PageNames.home);
  }

  void transitionNotice(PageNames current) {
    if (ref == null) return;
    final loginUser = ref!.read(loginUserProvider);

    if (loginUser == null) {
      PageService().showConfirmDialog(
          'お知らせを見るにはログインが必要です。'
          '\nDiscordでログインする。',
          () => LoginService().login());
    } else {
      PageService().transition(PageNames.notice);
    }
  }

  void transitionMyCalendar(PageNames current) {
    if (ref == null) return;
    final loginUser = ref!.read(loginUserProvider);

    if (loginUser == null) {
      PageService().showConfirmDialog(
          '予定表を見るにはログインが必要です。'
          '\nDiscordでログインする。',
          () => LoginService().login());
    } else {
      PageService()
          .transition(PageNames.calendar, arguments: {'uid': loginUser.uid});
    }
  }

  void viewCreateDialog(PageNames current) {
    if (ref == null) return;
    final loginUser = ref!.read(loginUserProvider);

    if (loginUser == null) {
      PageService().showConfirmDialog(
          '予定を作るにはログインが必要です。'
          '\nDiscordでログインする',
          () => LoginService().login());
    } else {
      showDialog(
          context: context!,
          barrierDismissible: true,
          builder: (_) {
            return const ScheduleCreateDialog();
          });
    }
  }
}
