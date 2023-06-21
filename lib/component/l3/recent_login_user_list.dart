import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/user_entity.dart';
import '../../model/user_model.dart';
import '../../provider/login_user_provider.dart';
import '../../provider/wait_time_search_provider.dart';
import '../base/base_sliver_list.dart';
import '../l1/list_label.dart';
import '../l2/user_card.dart';

class RecentLoginUserList extends HookConsumerWidget {
  final void Function(UserEntity user)? trailingOnTap;
  final String? trailingButtonText;

  const RecentLoginUserList({
    super.key,
    this.trailingOnTap,
    this.trailingButtonText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginUser = ref.watch(loginUserProvider);
    final searchInput = ref.watch(waitTimeSearchProvider);

    final List<String> excludeUidList = [];
    if (loginUser != null) excludeUidList.add(loginUser.uid);

    return BaseSliverList<UserEntity>(
      fetchFunction: (int pageKey) => UserModel()
          .getList(pageKey, searchInput, excludeUidList: excludeUidList),
      header: const ListLabel('直近ログイン'),
      noDataText: '条件に合うユーザーがいません。',
      rowBuilder: (UserEntity item) => UserCard(
        item,
        trailingOnTap: trailingOnTap,
        trailingButtonText: trailingButtonText,
      ),
      refresher: searchInput,
    );
  }
}
