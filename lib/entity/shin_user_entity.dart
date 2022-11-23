import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final shinUserProvider = StateNotifierProvider<ShinUserNotifer, ShinUserEntity>(
    (_) => ShinUserNotifer());

@immutable
class ShinUserEntity {
  final String id;
  final String name;

  const ShinUserEntity(this.id, this.name);
}

class ShinUserNotifer extends StateNotifier<ShinUserEntity> {
  ShinUserNotifer() : super({'aaa', 'taro'} as ShinUserEntity);

  // void increment() => state++;
}
