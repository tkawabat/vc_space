import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/user_entity.dart';
import '../../model/notice_model.dart';
import '../../provider/login_user_provider.dart';
import '../../route.dart';
import '../../service/page_service.dart';
import '../base/base_single_list.dart';
import '../l1/loading.dart';
import '../l2/notice_card.dart';

class NoticeList extends HookConsumerWidget {
  const NoticeList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserEntity? loginUser = ref.watch(loginUserProvider);
    if (loginUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PageService().transition(PageNames.home);
      });
      return const Loading();
    }

    return BaseSingleList(
      fetchFunction: (int pageKey) =>
          NoticeModel().getList(pageKey, loginUser.uid),
      noDataText: 'お知らせがありません',
      rowBuilder: (item) => NoticeCard(item),
    );
  }
}
