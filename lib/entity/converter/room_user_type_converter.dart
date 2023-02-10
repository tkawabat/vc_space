import 'package:json_annotation/json_annotation.dart';

import '../room_user_entity.dart';

class RoomUserTypeConverter implements JsonConverter<RoomUserType, int> {
  const RoomUserTypeConverter();

  @override
  RoomUserType fromJson(int value) {
    return RoomUserType.fromValue(value);
  }

  @override
  int toJson(RoomUserType roomUserType) {
    return roomUserType.value;
  }
}
