import 'package:json_annotation/json_annotation.dart';

import '../room_entity.dart';

class EnterTypeConverter implements JsonConverter<EnterType, String> {
  const EnterTypeConverter();

  @override
  EnterType fromJson(String text) {
    return EnterType.values.byName(text);
  }

  @override
  String toJson(EnterType value) {
    return value.name;
  }
}
