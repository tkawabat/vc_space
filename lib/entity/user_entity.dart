import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/datetime_converter.dart';

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

// TODO
UserEntity createSampleUser() {
  return UserEntity(
    id: 'user01',
    name: 'taro',
    photo:
        'https://pbs.twimg.com/profile_images/1245965644094246912/rOuCIpPu_normal.jpg',
    tags: ['a'],
    twitterId: '',
    blocks: [],
    updatedAt: DateTime.now(),
  );
}
