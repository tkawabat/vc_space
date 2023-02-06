// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/timestampz_converter.dart';
import 'user_data_entity.dart';

part 'chat_entity.freezed.dart';
part 'chat_entity.g.dart';

@freezed
class ChatEntity with _$ChatEntity {
  const factory ChatEntity({
    required int roomId,
    required int roomChatId,
    required String uid,
    required String text,
    @TimestampzConverter() required DateTime updatedAt,
    @JsonKey(name: 'user') required UserDataEntity userData,
  }) = _ChatEntity;

  factory ChatEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatEntityFromJson(json);
}
