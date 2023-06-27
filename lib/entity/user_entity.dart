// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/timestampz_converter.dart';
import '../service/const_system.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String uid,
    required String name,
    required String photo,
    @JsonKey(defaultValue: 'よろしくお願いします。') required String greeting,
    required String discordName,
    @JsonKey(defaultValue: []) required List<String> tags,
    required List<String> follows,
    required int followerNumber,
    @TimestampzConverter() required DateTime updatedAt,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}

final userOnLoad = UserEntity(
  uid: ConstSystem.userOnLoad,
  name: 'ロード中です',
  photo: '',
  discordName: '',
  greeting: '',
  tags: [],
  follows: [],
  followerNumber: 0,
  updatedAt: DateTime.now(),
);

final userNotFound = UserEntity(
  uid: ConstSystem.userNotFound,
  name: '存在しないユーザーです',
  photo: '',
  discordName: '',
  greeting: '',
  tags: [],
  follows: [],
  followerNumber: 0,
  updatedAt: DateTime.now(),
);
