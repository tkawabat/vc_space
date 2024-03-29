// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../service/time_service.dart';
import 'converter/timestampz_converter.dart';

part 'search_input_entity.freezed.dart';
part 'search_input_entity.g.dart';

@freezed
class SearchInputEntity with _$SearchInputEntity {
  const factory SearchInputEntity({
    @TimestampzConverter() required DateTime startTime,
    @TimestampzConverter() required DateTime endTime,
    required List<String> tags,
  }) = _SearchInputEntity;

  factory SearchInputEntity.fromJson(Map<String, dynamic> json) =>
      _$SearchInputEntityFromJson(json);
}

final searchInputDefault = SearchInputEntity(
  tags: [],
  startTime: TimeService().getDay(DateTime.now()),
  endTime: TimeService().getDay(DateTime.now()).copyWith(hour: 23, minute: 59),
);
