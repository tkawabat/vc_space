// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/timestampz_converter.dart';
import 'converter/enter_type_converter.dart';
import 'converter/room_status_converter.dart';
import 'converter/place_type_converter.dart';
import '../service/const_system.dart';
import 'room_user_entity.dart';

part 'room_entity.freezed.dart';
part 'room_entity.g.dart';

enum PlaceType {
  discord(10, 'Discord'),
  twitcasting(20, 'ツイキャス'),
  twitter(30, 'Twitterスペース'),
  zoom(40, 'Zoom'),
  spoon(50, 'Spoon'),
  none(90, '未定'),
  ;

  const PlaceType(this.value, this.displayName);
  final int value;
  final String displayName;

  factory PlaceType.fromValue(int value) {
    switch (value) {
      case 10:
        return PlaceType.discord;
      case 20:
        return PlaceType.twitcasting;
      case 30:
        return PlaceType.twitter;
      case 40:
        return PlaceType.zoom;
      case 50:
        return PlaceType.spoon;
      case 90:
        return PlaceType.none;
    }
    return PlaceType.none;
  }
}

enum EnterType {
  noLimit(10, '制限なし'),
  password(20, 'パスワード'),
  follow(30, 'フォローのみ'),
  ;

  const EnterType(this.value, this.displayName);
  final int value;
  final String displayName;

  factory EnterType.fromValue(int value) {
    switch (value) {
      case 10:
        return EnterType.noLimit;
      case 20:
        return EnterType.password;
      case 30:
        return EnterType.follow;
    }
    return EnterType.noLimit;
  }
}

enum RoomStatus {
  open(10, '募集中'),
  close(60, '募集終了'),
  deleted(80, '削除済み'),
  ;

  const RoomStatus(this.value, this.displayName);
  final int value;
  final String displayName;

  factory RoomStatus.fromValue(int value) {
    switch (value) {
      case 10:
        return RoomStatus.open;
      case 60:
        return RoomStatus.close;
      case 80:
        return RoomStatus.deleted;
    }
    throw Exception('RoomStatusType error. value=$value');
  }
}

@freezed
class RoomEntity with _$RoomEntity {
  const factory RoomEntity({
    required int roomId,
    required String owner,
    required String title,
    @JsonKey(defaultValue: '') required String description,
    @TimestampzConverter() required DateTime startTime,
    required int maxNumber,
    @EnterTypeConverter() required EnterType enterType,
    String? password,
    @PlaceTypeConverter() required PlaceType placeType,
    required List<String> tags,
    @RoomStatusConverter() required RoomStatus roomStatus,
    @TimestampzConverter() required DateTime updatedAt,
    @JsonKey(name: 'room_user') required List<RoomUserEntity> users,
  }) = _RoomEntity;

  factory RoomEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomEntityFromJson(json);
}

final roomNotFound = RoomEntity(
  roomId: ConstSystem.idNotFound,
  owner: '',
  title: '存在しない部屋です',
  description: '',
  startTime: DateTime.now(),
  maxNumber: 2,
  enterType: EnterType.password,
  placeType: PlaceType.none,
  tags: [],
  updatedAt: DateTime.now(),
  roomStatus: RoomStatus.deleted,
  users: [roomUserEmpty],
);
