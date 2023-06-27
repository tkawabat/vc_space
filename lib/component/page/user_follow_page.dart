import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/user_entity.dart';
import '../../model/function_model.dart';
import '../../route.dart';
import '../../service/page_service.dart';
import '../base/base_single_list.dart';
import '../l2/user_card.dart';
import '../l3/footer.dart';
import '../l3/header.dart';

class UserFollowPage extends HookConsumerWidget {
  final String uid;
  const UserFollowPage({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    return Scaffold(
      appBar: const Header(PageNames.userFollow, 'フォロー中'),
      bottomNavigationBar: const Footer(PageNames.userFollow),
      body: Column(
        children: [
          BaseSingleList<UserEntity>(
            fetchFunction: (int pageKey) =>
                FunctionModel().getFollows(pageKey, uid),
            noDataText: 'フォロー中のユーザーがいません',
            rowBuilder: (item) => UserCard(item),
          ),
        ],
      ),
    );
  }
}
