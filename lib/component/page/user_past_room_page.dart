import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/room_entity.dart';
import '../../model/room_model.dart';
import '../../route.dart';
import '../../service/page_service.dart';
import '../base/base_single_list.dart';
import '../l2/room_card.dart';
import '../l3/footer.dart';
import '../l3/header.dart';

class UserPastRoomPage extends HookConsumerWidget {
  final String uid;
  const UserPastRoomPage({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    return Scaffold(
      appBar: const Header(PageNames.userFollow, '参加履歴'),
      bottomNavigationBar: const Footer(PageNames.userFollow),
      body: Column(
        children: [
          BaseSingleList<RoomEntity>(
            fetchFunction: (int pageKey) =>
                RoomModel().getJoinPastList(pageKey, uid, null),
            noDataText: '参加した部屋がありません',
            rowBuilder: (item) => RoomCard(item),
          ),
        ],
      ),
    );
  }
}
