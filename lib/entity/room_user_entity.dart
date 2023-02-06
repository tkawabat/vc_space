// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vc_space/service/const_system.dart';

import 'converter/timestampz_converter.dart';
import 'converter/room_user_type_converter.dart';
import 'user_data_entity.dart';

part 'room_user_entity.freezed.dart';
part 'room_user_entity.g.dart';

enum RoomUserType {
  admin(10, '主催者'),
  member(20, '参加者'),
  offer(80, 'オファー中'),
  ;

  const RoomUserType(this.value, this.displayName);
  final int value;
  final String displayName;

  factory RoomUserType.fromValue(int value) {
    switch (value) {
      case 10:
        return RoomUserType.admin;
      case 20:
        return RoomUserType.member;
      case 30:
        return RoomUserType.offer;
    }
    throw Exception('RoomUserType error. value=$value');
  }
}

@freezed
class RoomUserEntity with _$RoomUserEntity {
  const factory RoomUserEntity({
    required int roomId,
    required String uid,
    @RoomUserTypeConverter() required RoomUserType roomUserType,
    @TimestampzConverter() required DateTime updatedAt,
    @JsonKey(name: 'user') required UserDataEntity userData,
  }) = _RoomUserEntity;

  factory RoomUserEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomUserEntityFromJson(json);
}

final roomUserEmpty = RoomUserEntity(
  roomId: ConstSystem.roomNotFound,
  uid: ConstSystem.userNotFound,
  roomUserType: RoomUserType.admin,
  updatedAt: ConstSystem.emptyTime,
  userData: userDataEmpty,
);
