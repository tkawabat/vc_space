import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/datetime_converter.dart';
import '../service/const_system.dart';

part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String name,
    required String photo,
    required List<String> tags,
    required String twitterId,
    required List<String> blocks,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}

final userOnLoad = UserEntity(
  id: ConstSystem.userOnLoad,
  name: 'ロード中です',
  photo: '',
  tags: [''],
  twitterId: '',
  blocks: [],
  updatedAt: DateTime.now(),
);

final userNotFound = UserEntity(
  id: ConstSystem.userNotFound,
  name: '存在しないユーザーです',
  photo: '',
  tags: [''],
  twitterId: '',
  blocks: [],
  updatedAt: DateTime.now(),
);
