import 'package:json_annotation/json_annotation.dart';

import '../room_entity.dart';

class EnterTypeConverter implements JsonConverter<EnterType, int> {
  const EnterTypeConverter();

  @override
  EnterType fromJson(int value) {
    return EnterType.fromValue(value);
  }

  @override
  int toJson(EnterType variable) {
    return variable.value;
  }
}
