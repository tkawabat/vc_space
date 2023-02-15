// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/timestampz_converter.dart';

part 'room_private_entity.freezed.dart';
part 'room_private_entity.g.dart';

@freezed
class RoomPrivateEntity with _$RoomPrivateEntity {
  const factory RoomPrivateEntity({
    required int roomId,
    @JsonKey(defaultValue: '') required String innerDescription,
    String? placeUrl,
    @TimestampzConverter() required DateTime updatedAt,
  }) = _RoomPrivateEntity;

  factory RoomPrivateEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomPrivateEntityFromJson(json);
}
