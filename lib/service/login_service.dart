import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import '../model/user_model.dart';
import '../provider/login_provider.dart';

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
    ref.read(loginProvider.notifier).set(currentUser?.id, ref);

    debugPrint(currentUser?.id);

    // ユーザー更新
    if (currentUser != null &&
        currentUser.userMetadata != null &&
        currentUser.userMetadata!.isNotEmpty) {
      final meta = currentUser.userMetadata!;
      final user = await UserModel().upsertOnView(
          currentUser.id, meta['full_name'], meta['avatar_url'], meta['name']);
      if (user != null) {
        ref.read(loginUserProvider.notifier).set(user);
      }
    }
  }

  Future<void> login() async {
    await auth.signInWithOAuth(supa.Provider.discord);
  }

  Future<void> logout() async {
    await auth.signOut();

    // ユーザー情報を捨てる
  }
}
