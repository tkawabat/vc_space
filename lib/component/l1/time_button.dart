import 'package:flutter/material.dart';

import '../../extension/time_of_day_extensions.dart';
import '../../service/const_service.dart';

class TimeButton extends StatelessWidget {
  final TimeOfDay initialValue;
  final void Function(TimeOfDay?) onChanged;
  final TimeOfDay start;
  final TimeOfDay? end;
  final Alignment alignment;

  const TimeButton({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.start = const TimeOfDay(hour: 0, minute: 0),
    this.end,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<TimeOfDay>> items = [];
    var time = TimeOfDay(hour: start.hour, minute: start.minute);
    while (true) {
      items.add(DropdownMenuItem(
        value: time,
        child: Text(time.toTimeString()),
      ));

      final minute = time.minute + ConstService.stepTime;

      // ループ終了判定
      if (end != null && time.hour >= end!.hour && time.minute >= end!.minute) {
        break;
      }
      if (time.hour == 23 && minute == 60) {
        const endTime = TimeOfDay(hour: 23, minute: 59);
        items.add(DropdownMenuItem(
          value: endTime,
          child: Text(endTime.toTimeString()),
        ));
        break;
      }

      // update
      time = TimeOfDay(hour: time.hour + minute ~/ 60, minute: minute % 60);
    }

    return Align(
      alignment: alignment,
      child: DropdownButton<TimeOfDay>(
        items: items,
        value: initialValue,
        isDense: true,
        iconSize: 16,
        onChanged: onChanged,
      ),
    );
  }
}
