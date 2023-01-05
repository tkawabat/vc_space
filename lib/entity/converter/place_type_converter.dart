import 'package:json_annotation/json_annotation.dart';

import '../room_entity.dart';

class PlaceTypeConverter implements JsonConverter<PlaceType, String> {
  const PlaceTypeConverter();

  @override
  PlaceType fromJson(String text) {
    return PlaceType.values.byName(text);
  }

  @override
  String toJson(PlaceType value) {
    return value.name;
  }
}
