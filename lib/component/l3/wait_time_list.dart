import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/user_entity.dart';
import '../../entity/wait_time_entity.dart';
import '../../model/wait_time_model.dart';
import '../../provider/wait_time_search_provider.dart';
import '../../service/wait_time_service.dart';
import '../base/base_sliver_list.dart';
import '../l1/list_label.dart';
import '../l2/user_card.dart';

class WaitTimeList extends HookConsumerWidget {
  final void Function(UserEntity user)? trailingOnTap;
  final String? trailingButtonText;
  final List<String> excludeUidList;

  const WaitTimeList({
    super.key,
    this.trailingOnTap,
    this.trailingButtonText,
    this.excludeUidList = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchInput = ref.watch(waitTimeSearchProvider);

    return BaseSliverList<WaitTimeEntity>(
      fetchFunction: (int pageKey) =>
          WaitTimeModel().getList(pageKey, searchInput),
      header: const ListLabel('誘って！'),
      noDataText: '誘って！　がありません',
      rowBuilder: (WaitTimeEntity item) => UserCard(
        item.user,
        body: Container(
          padding: const EdgeInsets.fromLTRB(0, 4, 16, 4),
          alignment: Alignment.topRight,
          child: Text(WaitTimeService().toDisplayText(item)),
        ),
        trailingOnTap: trailingOnTap,
        trailingButtonText: trailingButtonText,
      ),
      refresher: searchInput,
    );
  }
}
