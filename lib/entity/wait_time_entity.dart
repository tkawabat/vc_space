import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/timestampz_converter.dart';

part 'wait_time_entity.freezed.dart';
part 'wait_time_entity.g.dart';

@freezed
class WaitTimeEntity with _$WaitTimeEntity {
  const factory WaitTimeEntity({
    required String uid,
    required int waitTimeId,
    @TimestampzConverter() required DateTime startTime,
    @TimestampzConverter() required DateTime endTime,
    @TimestampzConverter() required DateTime updatedAt,
  }) = _WaitTimeEntity;

  factory WaitTimeEntity.fromJson(Map<String, dynamic> json) =>
      _$WaitTimeEntityFromJson(json);
}
