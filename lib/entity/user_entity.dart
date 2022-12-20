import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_entity.freezed.dart';
part 'user_entity.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity(
      {required String id,
      required String name,
      required String photo,
      required List<String> tags,
      required String twitterId}) = _UserEntity;

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}

UserEntity createSampleUser() {
  return UserEntity.fromJson({
    'id': 'user01',
    'name': 'taro',
    'photo': '',
    'tags': ['a'],
    'twitterId': '',
  });
}
