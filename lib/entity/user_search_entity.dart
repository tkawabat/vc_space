// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_entity.dart';
import 'wait_time_entity.dart';

part 'user_search_entity.freezed.dart';
part 'user_search_entity.g.dart';

@freezed
class UserSearchEntity with _$UserSearchEntity {
  const factory UserSearchEntity({
    @JsonKey(name: 'user_data') required UserEntity user,
    WaitTimeEntity? waitTime,
  }) = _UserSearchEntity;

  factory UserSearchEntity.fromJson(Map<String, dynamic> json) =>
      _$UserSearchEntityFromJson(json);
}
