// ignore_for_file: invalid_annotation_target

// json_serialize内で使っているので消しちゃだめ
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/datetime_converter.dart';

part 'chat_entity.freezed.dart';
part 'chat_entity.g.dart';

@freezed
class ChatEntity with _$ChatEntity {
  const factory ChatEntity({
    required String id,
    required String userId,
    required String text,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _ChatEntity;

  factory ChatEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatEntityFromJson(json);
}
