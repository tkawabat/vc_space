import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ModelBase {
  final supabase = Supabase.instance.client;

  String encodePassword(String? password) {
    return base64.encode(sha256.convert(base64.decode(password ?? '')).bytes);
  }
}
