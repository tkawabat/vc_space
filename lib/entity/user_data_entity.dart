// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data_entity.freezed.dart';
part 'user_data_entity.g.dart';

/// joinしたときに利用するentity
@freezed
class UserDataEntity with _$UserDataEntity {
  const factory UserDataEntity({
    required String name,
    required String photo,
    required String discordName,
  }) = _UserDataEntity;

  factory UserDataEntity.fromJson(Map<String, dynamic> json) =>
      _$UserDataEntityFromJson(json);
}

const userDataEmpty = UserDataEntity(name: '', photo: '', discordName: '');
