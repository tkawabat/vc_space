// ignore_for_file: invalid_annotation_target

// json_serialize内で使っているので消しちゃだめ
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/datetime_converter.dart';
import 'converter/room_user_type_converter.dart';

part 'room_user_entity.freezed.dart';
part 'room_user_entity.g.dart';

enum RoomUserType {
  admin('主催者'),
  member('参加者'),
  offer('オファー中'),
  ;

  const RoomUserType(this.displayName);
  final String displayName;
}

@freezed
class RoomUserEntity with _$RoomUserEntity {
  const factory RoomUserEntity({
    required String id,
    required String photo,
    @RoomUserTypeConverter() required RoomUserType roomUserType,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _RoomUserEntity;

  factory RoomUserEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomUserEntityFromJson(json);
}
