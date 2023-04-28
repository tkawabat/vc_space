import 'package:flutter/material.dart';

extension TimeOfDayExtension on TimeOfDay {
  String toTimeString() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  double toDouble() => hour + minute / 60.0;
  bool isAfter(TimeOfDay time) => toDouble() > time.toDouble();
  TimeOfDay add({int hours = 0, int minutes = 0}) => TimeOfDay(
      hour: hour + hours + minutes ~/ 60, minute: minute + minutes % 60);
  bool canAdd({int hours = 0, int minutes = 0}) =>
      hour + hours + minutes ~/ 60 < 24;
}
