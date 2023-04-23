// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/timestampz_converter.dart';

part 'user_search_input_entity.freezed.dart';
part 'user_search_input_entity.g.dart';

@freezed
class UserSearchInputEntity with _$UserSearchInputEntity {
  const factory UserSearchInputEntity({
    @TimestampzConverter() required DateTime time,
    required List<String> tags,
  }) = _UserSearchInputEntity;

  factory UserSearchInputEntity.fromJson(Map<String, dynamic> json) =>
      _$UserSearchInputEntityFromJson(json);
}

final userSearchInputDefault = UserSearchInputEntity(
  tags: [],
  time: DateTime.now(),
);
