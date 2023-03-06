import 'package:flutter/material.dart';

import '../l1/square_button.dart';
import '../l1/cancel_button.dart';
import 'room_edit_dialog.dart';
import 'wait_time_create_dialog.dart';

class ScheduleCreateDialog extends StatelessWidget {
  const ScheduleCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('予定を作る'),
        content: SizedBox(
            width: 220,
            height: 120,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SquareButton(
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) {
                          return const WaitTimeCreateDialog();
                        });
                  },
                  text: '空き時間',
                  icon: Icons.calendar_month,
                ),
                SquareButton(
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (_) {
                          return RoomEditDialog();
                        });
                  },
                  text: '部屋',
                  icon: Icons.home,
                ),
              ],
            )),
        actions: const [
          CancelButton(),
        ]);
  }
}
