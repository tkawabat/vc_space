import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();

  factory SupabaseService() {
    return _instance;
  }

  SupabaseService._internal();

  Future<void> initialize() async {
    if (dotenv.get('ENV') == 'production') {
      await Supabase.initialize(
        url: dotenv.get('SUPABASE_URL'),
        anonKey: dotenv.get('SUPABASE_ANON_KEY'),
      );
    } else {
      // auth機能だけ本番を利用するので、はじめはauth
      await Supabase.initialize(
        url: dotenv.get('SUPABASE_AUTH_URL'),
        anonKey: dotenv.get('SUPABASE_AUTH_ANON_KEY'),
      );
    }
  }

  Future<void> reconnect() async {
    // 本番なら何もしない
    if (dotenv.get('ENV') == 'production') return;

    Supabase.instance.dispose();
    await Supabase.initialize(
      url: dotenv.get('SUPABASE_URL'),
      anonKey: dotenv.get('SUPABASE_ANON_KEY'),
    );
  }

  Future<void> reconnectAuth() async {
    // 本番なら何もしない
    if (dotenv.get('ENV') == 'production') return;

    Supabase.instance.dispose();
    await Supabase.initialize(
      url: dotenv.get('SUPABASE_AUTH_URL'),
      anonKey: dotenv.get('SUPABASE_AUTH_ANON_KEY'),
    );
  }
}
