import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/wait_time_entity.dart';
import '../../provider/login_user_provider.dart';
import '../../service/page_service.dart';
import '../../service/wait_time_service.dart';
import '../l1/card_base.dart';

class WaitTimeCard extends ConsumerWidget {
  final WaitTimeEntity waitTime;
  final String uid;

  const WaitTimeCard(this.waitTime, this.uid, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loginUserProvider);

    final bool canDelete = user != null && user.uid == uid;

    return CardBase(children: [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        title: Text(WaitTimeService().toDisplayText(waitTime)),
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
      )
    ]);
  }
}
