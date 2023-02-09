// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/timestampz_converter.dart';
import 'user_data_entity.dart';

part 'room_chat_entity.freezed.dart';
part 'room_chat_entity.g.dart';

@freezed
class RoomChatEntity with _$RoomChatEntity {
  const factory RoomChatEntity({
    required int roomId,
    required int roomChatId,
    required String uid,
    required String text,
    @TimestampzConverter() required DateTime updatedAt,
    @JsonKey(name: 'user') required UserDataEntity userData,
  }) = _RoomChatEntity;

  factory RoomChatEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomChatEntityFromJson(json);
}
