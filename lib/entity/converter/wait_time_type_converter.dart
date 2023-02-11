import 'package:json_annotation/json_annotation.dart';

import '../wait_time_entity.dart';

class WaitTimeTypeConverter implements JsonConverter<WaitTimeType, int> {
  const WaitTimeTypeConverter();

  @override
  WaitTimeType fromJson(int value) {
    return WaitTimeType.fromValue(value);
  }

  @override
  int toJson(WaitTimeType waitTimeType) {
    return waitTimeType.value;
  }
}
