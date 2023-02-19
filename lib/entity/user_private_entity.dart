// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/timestampz_converter.dart';
import 'user_data_entity.dart';

part 'user_private_entity.freezed.dart';
part 'user_private_entity.g.dart';

@freezed
class UserPrivateEntity with _$UserPrivateEntity {
  const factory UserPrivateEntity({
    required String uid,
    required List<String> blocks,
    @TimestampzConverter() required DateTime noticeReadTime,
    @TimestampzConverter() required DateTime updatedAt,
    @JsonKey(name: 'users') required List<UserDataEntity> users,
  }) = _UserPrivateEntity;

  factory UserPrivateEntity.fromJson(Map<String, dynamic> json) =>
      _$UserPrivateEntityFromJson(json);
}
