import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

import 'supabase_service.dart';
import '../provider/login_provider.dart';

class LoginService {
  static final LoginService _instance = LoginService._internal();
  final auth = supa.Supabase.instance.client.auth;
  supa.User? user;

  factory LoginService() {
    return _instance;
  }

  LoginService._internal();

  /// 起動時にユーザーを変数にセットする
  ///
  /// dockerのsupabaseでAuth機能がないため、開発時にここだけ本番環境を見に行く
  Future<void> setUser() async {
    user = auth.currentUser;
  }

  /// ページ表示後にuser情報をproviderに設定する
  void initializeUser(WidgetRef ref) {
    ref.read(loginProvider.notifier).set(user?.id, ref);

    debugPrint(user?.id);

    // ユーザー更新

    // ユーザー取得
  }

  Future<void> login() async {
    SupabaseService().reconnectAuth();
    await auth.signInWithOAuth(supa.Provider.discord);
  }

  Future<void> logout() async {
    await SupabaseService().reconnectAuth();
    await auth.signOut();
    await SupabaseService().reconnect();

    // ユーザー情報を捨てる
  }
}
