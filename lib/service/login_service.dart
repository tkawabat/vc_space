import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import '../component/dialog/wait_time_create_dialog.dart';
import '../model/user_model.dart';
import '../provider/login_user_private_provider.dart';
import '../provider/login_user_provider.dart';
import '../provider/notice_list_provider.dart';
import '../provider/room_list_join_provider.dart';
// import '../provider/room_search_provider.dart';
import '../provider/wait_time_list_provider.dart';
import 'analytics_service.dart';
import 'page_service.dart';
import 'wait_time_service.dart';

class LoginService {
  static final LoginService _instance = LoginService._internal();
  final auth = supa.Supabase.instance.client.auth;

  factory LoginService() {
    return _instance;
  }

  LoginService._internal();

  /// ページ表示後にuser情報をproviderに設定する
  Future<void> initializeUser(WidgetRef ref) async {
    final currentUser = auth.currentUser;

    // ユーザー更新
    if (currentUser != null &&
        currentUser.userMetadata != null &&
        currentUser.userMetadata!.isNotEmpty) {
      final meta = currentUser.userMetadata!;
      final user = await UserModel().upsertOnView(
          currentUser.id, meta['full_name'], meta['avatar_url'], meta['name']);

      if (user != null) {
        PageService().snackbar('ログインしました', SnackBarType.info);
        ref.read(loginUserProvider.notifier).set(user);
        ref.read(loginUserPrivateProvider.notifier).get(user.uid);
        ref.read(roomListJoinProvider.notifier).getList(user.uid);
        ref.read(waitTimeListProvider.notifier).getList(user.uid).then((_) {
          if (PageService().context == null) return;
          if (PageService().canBack()) return;
          if (!WaitTimeService().isViewDialog()) return;

          WaitTimeService().addNoWait(user);
          showDialog(
              context: PageService().context!,
              barrierDismissible: true,
              builder: (_) {
                return const WaitTimeCreateDialog();
              });
        });
        ref.read(noticeListProvider.notifier).startUpdate(user.uid);

        // 人増えるまではなし
        // if (user.tags.isNotEmpty) {
        //   ref.read(roomSearchProvider.notifier).setTags([user.tags[0]]);
        // }
      }
    }
  }

  Future<void> login() async {
    await auth.signInWithOAuth(supa.Provider.discord).then((value) {
      if (value) {
        logEvent(LogEventName.login, 'user');
      }
    });
  }

  Future<void> logout(WidgetRef ref) async {
    await auth.signOut();

    logEvent(LogEventName.logout, 'user');
    ref.read(loginUserProvider.notifier).set(null);
    PageService().snackbar('ログアウトしました', SnackBarType.info);
  }
}
