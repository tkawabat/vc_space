// ignore_for_file: invalid_annotation_target

// json_serialize内で使っているので消しちゃだめ
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_entity.dart';
import 'room_user_entity.dart';
import 'converter/datetime_converter.dart';
import 'converter/enter_type_converter.dart';
import 'converter/place_type_converter.dart';
import '../service/const_system.dart';

part 'room_entity.freezed.dart';
part 'room_entity.g.dart';

enum PlaceType {
  discord('Discord'),
  twitcasting('ツイキャス'),
  twitter('Twitterスペース'),
  zoom('Zoom'),
  spoon('Spoon'),
  none('未定'),
  ;

  const PlaceType(this.displayName);
  final String displayName;
}

enum EnterType {
  noLimit('制限なし'),
  // follow('フォローのみ'),
  password('パスワード'),
  ;

  const EnterType(this.displayName);
  final String displayName;
}

@freezed
class RoomEntity with _$RoomEntity {
  const factory RoomEntity({
    required String id,
    required String title,
    @JsonKey(defaultValue: '') required String description,
    @PlaceTypeConverter() required PlaceType place,
    String? placeUrl,
    @DateTimeConverter() required DateTime startTime,
    required List<String> tags,
    required int maxNumber,
    @EnterTypeConverter() required EnterType enterType,
    String? password,
    required List<RoomUserEntity> users,
    required List<ChatEntity> chats,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _RoomEntity;

  factory RoomEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomEntityFromJson(json);
}

final roomNotFound = RoomEntity(
    id: ConstSystem.roomNotFound,
    title: '存在しない部屋です',
    description: '',
    place: PlaceType.none,
    startTime: DateTime.now(),
    tags: [],
    maxNumber: 2,
    enterType: EnterType.password,
    users: [],
    chats: [],
    updatedAt: DateTime.now());
