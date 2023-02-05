// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_owner_entity.freezed.dart';
part 'room_owner_entity.g.dart';

@freezed
class RoomOwnerEntity with _$RoomOwnerEntity {
  const factory RoomOwnerEntity({
    required String name,
    required String photo,
  }) = _RoomOwnerEntity;

  factory RoomOwnerEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomOwnerEntityFromJson(json);
}
