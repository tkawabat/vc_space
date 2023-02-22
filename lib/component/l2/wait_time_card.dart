import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../entity/wait_time_entity.dart';
import '../../provider/login_user_provider.dart';
import '../../service/page_service.dart';
import '../../service/wait_time_service.dart';

class WaitTimeCard extends ConsumerWidget {
  final WaitTimeEntity waitTime;
  final String uid;

  const WaitTimeCard(this.waitTime, this.uid, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loginUserProvider);

    String startTime =
        DateFormat('M/d(E) HH:mm', 'ja_JP').format(waitTime.startTime);
    String endTime = DateFormat('HH:mm', 'ja_JP').format(waitTime.endTime);
    final String title = '空き時間: $startTime 〜 $endTime';

    final bool canDelete = user != null && user.uid == uid;

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Card(
            elevation: 4,
            shadowColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text(title),
              trailing: canDelete
                  ? IconButton(
                      tooltip: '削除する',
                      icon: const Icon(Icons.delete),
                      onPressed: () => PageService().showConfirmDialog(
                          '空き時間を削除しますか？',
                          () => WaitTimeService()
                              .delete(user.uid, waitTime.waitTimeId)),
                    )
                  : null,
            )));
  }
}
