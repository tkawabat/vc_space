import 'package:json_annotation/json_annotation.dart';

import '../room_entity.dart';

class PlaceTypeConverter implements JsonConverter<PlaceType, int> {
  const PlaceTypeConverter();

  @override
  PlaceType fromJson(int value) {
    return PlaceType.fromValue(value);
  }

  @override
  int toJson(PlaceType placeType) {
    return placeType.value;
  }
}
