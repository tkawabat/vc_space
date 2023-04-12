import 'package:json_annotation/json_annotation.dart';

import '../room_entity.dart';

class RoomStatusConverter implements JsonConverter<RoomStatus, int> {
  const RoomStatusConverter();

  @override
  RoomStatus fromJson(int value) {
    return RoomStatus.fromValue(value);
  }

  @override
  int toJson(RoomStatus variable) {
    return variable.value;
  }
}
