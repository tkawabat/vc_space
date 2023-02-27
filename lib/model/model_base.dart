import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ModelBase {
  final supabase = Supabase.instance.client;

  Map<String, dynamic> selectUpdateColumn(
    Map<String, dynamic> base,
    List<String>? targetColumnList,
  ) {
    if (targetColumnList == null) return base;

    Map<String, dynamic> newJson = {};
    for (var key in targetColumnList) {
      newJson[key] = base[key]!;
    }
    return newJson;
  }

  String encodePassword(String? password) {
    return base64.encode(sha256.convert(base64.decode(password ?? '')).bytes);
  }
}
