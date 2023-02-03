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
  void initializeUser(WidgetRef ref) {
    final user = auth.currentUser;
    ref.read(loginProvider.notifier).set(user?.id, ref);

    debugPrint(user?.id);

    // ユーザー更新

    // ユーザー取得
  }

  Future<void> login() async {
    await auth.signInWithOAuth(supa.Provider.discord);
  }

  Future<void> logout() async {
    await auth.signOut();

    // ユーザー情報を捨てる
  }
}
