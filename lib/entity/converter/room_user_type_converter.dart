import 'package:json_annotation/json_annotation.dart';

import '../room_user_entity.dart';

class RoomUserTypeConverter implements JsonConverter<RoomUserType, String> {
  const RoomUserTypeConverter();

  @override
  RoomUserType fromJson(String text) {
    return RoomUserType.values.byName(text);
  }

  @override
  String toJson(RoomUserType value) {
    return value.name;
  }
}
