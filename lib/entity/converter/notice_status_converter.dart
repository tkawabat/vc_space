import 'package:json_annotation/json_annotation.dart';

import '../notice_entity.dart';

class NoticeStatusConverter implements JsonConverter<NoticeStatus, int> {
  const NoticeStatusConverter();

  @override
  NoticeStatus fromJson(int value) {
    return NoticeStatus.fromValue(value);
  }

  @override
  int toJson(NoticeStatus variable) {
    return variable.value;
  }
}
