import 'package:flutter/material.dart';

class CalendarMaker extends StatelessWidget {
  final int num;
  final Color color;

  const CalendarMaker({
    required this.num,
    this.color = Colors.black54,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (num == 0) return const SizedBox();
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 12.0,
      height: 12.0,
      child: Center(
        child: Text(num.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.0,
            )),
      ),
    );
  }
}
