import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../entity/user_entity.dart';
import '../../provider/login_user_provider.dart';
import '../../service/const_design.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../../service/time_service.dart';
import '../../service/wait_time_service.dart';
import '../l1/cancel_button.dart';
import '../l1/time_button.dart';

class WaitTimeCreateDialog extends HookConsumerWidget {
  const WaitTimeCreateDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = TimeService().today();
    final now = TimeService().getStepNow(ConstService.stepTime);
    TimeOfDay start = TimeOfDay.fromDateTime(now);
    TimeOfDay end = TimeOfDay.fromDateTime(now.add(const Duration(hours: 2)));

    if (now.hour >= 23 && now.minute > 30) {
      date.add(const Duration(days: 1));
      start = const TimeOfDay(hour: 0, minute: 0);
      end = const TimeOfDay(hour: 2, minute: 0);
    } else if (now.hour >= 22) {
      start = const TimeOfDay(hour: 22, minute: 0);
      end = const TimeOfDay(hour: 23, minute: 59);
    }

    String dateText = DateFormat('M/d(E)', 'ja_JP').format(date);
    final startState = useState(start);
    final endState = useState(end);

    return AlertDialog(
        title: const Text('"誘って！"を登録しませんか？'),
        content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(dateText),
                    const SizedBox(width: 2),
                    TimeButton(
                      initialValue: start,
                      onChanged: (time) {
                        if (time == null) return;
                        startState.value = time;
                      },
                    ),
                    const Text('〜'),
                    TimeButton(
                      initialValue: end,
                      onChanged: (time) {
                        if (time == null) return;
                        endState.value = time;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '登録すると部屋の主催者の\n誘うリストに表示されます',
                    style: ConstDesign.caution,
                  ),
                )
              ],
            )),
        actions: [
          const CancelButton(),
          TextButton(
              child: const Text('登録'),
              onPressed: () {
                Navigator.pop(context);

                final UserEntity? loginUser = ref.read(loginUserProvider);
                if (loginUser == null) {
                  PageService()
                      .snackbar('空き時間を登録するにはログインが必要です', SnackBarType.error);
                  return;
                }
                final startTime =
                    date.copyWith(hour: start.hour, minute: start.minute);
                final endTime =
                    date.copyWith(hour: end.hour, minute: end.minute);
                WaitTimeService().add(loginUser, startTime, endTime);
              }),
        ]);
  }
}
