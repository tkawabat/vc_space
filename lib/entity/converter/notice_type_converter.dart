import 'package:json_annotation/json_annotation.dart';

import '../notice_entity.dart';

class NoticeTypeConverter implements JsonConverter<NoticeType, int> {
  const NoticeTypeConverter();

  @override
  NoticeType fromJson(int value) {
    return NoticeType.fromValue(value);
  }

  @override
  int toJson(NoticeType NoticeType) {
    return NoticeType.value;
  }
}
