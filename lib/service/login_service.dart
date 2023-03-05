import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import '../model/user_model.dart';
import '../provider/login_user_private_provider.dart';
import '../provider/login_user_provider.dart';
import '../provider/notice_list_provider.dart';
import '../provider/room_list_join_provider.dart';
import '../provider/room_search_provider.dart';
import 'page_service.dart';

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
        ref.read(noticeListProvider.notifier).startUpdate(user.uid);
        if (user.tags.isNotEmpty) {
          ref.read(roomSearchProvider.notifier).setTags([user.tags[0]]);
        }
      }
    }
  }

  Future<void> login() async {
    await auth.signInWithOAuth(supa.Provider.discord);
  }

  Future<void> logout(WidgetRef ref) async {
    await auth.signOut();

    ref.read(loginUserProvider.notifier).set(null);
    PageService().snackbar('ログアウトしました', SnackBarType.info);
  }
}
