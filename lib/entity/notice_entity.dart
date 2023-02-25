// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import 'converter/timestampz_converter.dart';
import 'converter/notice_type_converter.dart';
import 'converter/notice_status_converter.dart';
import 'room_entity.dart';
import 'user_data_entity.dart';

part 'notice_entity.freezed.dart';
part 'notice_entity.g.dart';

enum NoticeType {
  followed(100),
  followerCreateRoom(200),
  roomMemberAdded(300),
  roomDeleted(301),
  roomOffered(310),
  roomKicked(320),
  ;

  const NoticeType(this.value);
  final int value;

  factory NoticeType.fromValue(int value) {
    switch (value) {
      case 100:
        return NoticeType.followed;
      case 200:
        return NoticeType.followerCreateRoom;
      case 300:
        return NoticeType.roomMemberAdded;
      case 301:
        return NoticeType.roomDeleted;
      case 310:
        return NoticeType.roomOffered;
      case 320:
        return NoticeType.roomKicked;
    }
    throw Exception('NoticeType error. value=$value');
  }
}

// 今は使わない
enum NoticeStatus {
  unread(10, '未読'),
  ;

  const NoticeStatus(this.value, this.message);
  final int value;
  final String message;

  factory NoticeStatus.fromValue(int value) {
    switch (value) {
      case 10:
        return NoticeStatus.unread;
    }
    throw Exception('NoticeType error. value=$value');
  }
}

@freezed
class NoticeEntity with _$NoticeEntity {
  const factory NoticeEntity({
    required int noticeId,
    required String uid,
    @NoticeTypeConverter() required NoticeType noticeType,
    @NoticeStatusConverter() required NoticeStatus noticeStatus,
    String? idUser,
    int? idRoom,
    String? message,
    @TimestampzConverter() required DateTime createdAt,
    @TimestampzConverter() required DateTime updatedAt,
    @JsonKey(name: 'user') UserDataEntity? userData,
    @JsonKey(name: 'room') RoomEntity? roomData,
  }) = _NoticeEntity;

  factory NoticeEntity.fromJson(Map<String, dynamic> json) =>
      _$NoticeEntityFromJson(json);
}
