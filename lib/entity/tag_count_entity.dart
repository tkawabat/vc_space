// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/timestampz_converter.dart';

part 'tag_count_entity.freezed.dart';
part 'tag_count_entity.g.dart';

@freezed
class TagCountEntity with _$TagCountEntity {
  const factory TagCountEntity({
    @JsonKey(name: 'cal') @TimestampzConverter() required DateTime time,
    required int n,
  }) = _TagCountEntity;

  factory TagCountEntity.fromJson(Map<String, dynamic> json) =>
      _$TagCountEntityFromJson(json);
}
