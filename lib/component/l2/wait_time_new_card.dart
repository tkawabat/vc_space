import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../provider/wait_time_new_list_provider.dart';
import '../l1/card_base.dart';
import '../l1/time_button.dart';

class WaitTimeNewCard extends HookConsumerWidget {
  final NewWaitTime newWaitTime;
  const WaitTimeNewCard(this.newWaitTime, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CardBase(children: [
      ListTile(
        title: buildTitle(newWaitTime, ref),
        trailing: IconButton(
          tooltip: '削除する',
          icon: const Icon(Icons.delete),
          onPressed: () =>
              ref.read(waitTimeNewListProvider.notifier).delete(newWaitTime.id),
        ),
      )
    ]);
  }

  Widget buildTitle(NewWaitTime newWaitTime, WidgetRef ref) {
    String date = DateFormat('M/d(E)', 'ja_JP').format(newWaitTime.range.start);

    return Row(
      children: [
        Text('誘って！ $date '),
        TimeButton(
          initialValue: TimeOfDay.fromDateTime(newWaitTime.range.start),
          end: const TimeOfDay(hour: 23, minute: 0),
          onChanged: (time) {
            if (time == null) return;
            final replace = newWaitTime.range.start
                .copyWith(hour: time.hour, minute: time.minute);

            // endの時間がおかしかったら補正する
            var end = newWaitTime.range.end;
            if (replace.isBefore(end)) {
              // ok
            } else if (time.hour >= 22) {
              end = end.copyWith(hour: 23, minute: 59);
            } else {
              end = replace.add(const Duration(hours: 2));
            }

            ref.read(waitTimeNewListProvider.notifier).set(
                  newWaitTime.id,
                  DateTimeRange(start: replace, end: end),
                );
          },
        ),
        const Text('〜'),
        TimeButton(
          initialValue: TimeOfDay.fromDateTime(newWaitTime.range.end),
          start: TimeOfDay.fromDateTime(newWaitTime.range.start),
          onChanged: (time) {
            if (time == null) return;
            final replace = newWaitTime.range.end
                .copyWith(hour: time.hour, minute: time.minute);
            ref.read(waitTimeNewListProvider.notifier).set(
                  newWaitTime.id,
                  DateTimeRange(start: newWaitTime.range.start, end: replace),
                );
          },
        ),
      ],
    );
  }
}
