// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/timestampz_converter.dart';

part 'user_private_entity.freezed.dart';
part 'user_private_entity.g.dart';

@freezed
class UserPrivateEntity with _$UserPrivateEntity {
  const factory UserPrivateEntity({
    required String uid,
    required List<String> blocks,
    @TimestampzConverter() required DateTime noticeReadTime,
    required List<int> noPushList,
    required List<String> fcmTokens,
    @TimestampzConverter() required DateTime updatedAt,
  }) = _UserPrivateEntity;

  factory UserPrivateEntity.fromJson(Map<String, dynamic> json) =>
      _$UserPrivateEntityFromJson(json);
}
