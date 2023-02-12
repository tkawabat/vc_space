import 'package:json_annotation/json_annotation.dart';

class TimestampzConverter implements JsonConverter<DateTime, String> {
  const TimestampzConverter();

  @override
  DateTime fromJson(String timestampz) {
    return DateTime.parse(timestampz).toLocal();
  }

  @override
  String toJson(DateTime time) {
    return time.toUtc().toIso8601String();
  }
}
