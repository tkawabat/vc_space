// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/timestampz_converter.dart';

part 'room_chat_entity.freezed.dart';
part 'room_chat_entity.g.dart';

@freezed
class RoomChatEntity with _$RoomChatEntity {
  const factory RoomChatEntity({
    required int roomId,
    required int roomChatId,
    required String uid,
    required String text,
    required String name,
    required String photo,
    @TimestampzConverter() required DateTime updatedAt,
  }) = _RoomChatEntity;

  factory RoomChatEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomChatEntityFromJson(json);
}
