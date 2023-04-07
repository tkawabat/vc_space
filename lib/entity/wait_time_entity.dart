// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/timestampz_converter.dart';
import 'converter/wait_time_type_converter.dart';

part 'wait_time_entity.freezed.dart';
part 'wait_time_entity.g.dart';

enum WaitTimeType {
  valid(10),
  noWait(20),
  ;

  const WaitTimeType(this.value);
  final int value;

  factory WaitTimeType.fromValue(int value) {
    switch (value) {
      case 10:
        return WaitTimeType.valid;
      case 20:
        return WaitTimeType.noWait;
    }
    return WaitTimeType.valid;
  }
}

@freezed
class WaitTimeEntity with _$WaitTimeEntity {
  const factory WaitTimeEntity({
    required String uid,
    required int waitTimeId,
    @WaitTimeTypeConverter() required WaitTimeType waitTimeType,
    @TimestampzConverter() required DateTime startTime,
    @TimestampzConverter() required DateTime endTime,
    @TimestampzConverter() required DateTime updatedAt,
  }) = _WaitTimeEntity;

  factory WaitTimeEntity.fromJson(Map<String, dynamic> json) =>
      _$WaitTimeEntityFromJson(json);
}
