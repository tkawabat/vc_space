import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/user_entity.dart';
import '../../provider/enter_room_provider.dart';
import '../../provider/wait_time_search_provider.dart';
import '../../route.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../l1/loading.dart';
import '../l2/tag_field.dart';
import '../l3/footer.dart';
import '../l3/header.dart';
import '../l3/recent_login_user_list.dart';
import '../l3/wait_time_list.dart';

class RoomOfferPage extends HookConsumerWidget {
  const RoomOfferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);
    final room = ref.watch(enterRoomProvider);

    if (room == null) {
      return const Loading();
    }

    trailingOnTap(UserEntity user) async {
      if (RoomService().isJoined(room, user.uid)) {
        PageService().snackbar('既に部屋にいるユーザーです。', SnackBarType.error);
        return;
      }

      final success = await RoomService().offer(room, user);
      if (success) PageService().back();
    }

    return Scaffold(
      appBar: const Header(PageNames.roomOffer, '部屋に誘う'),
      bottomNavigationBar: const Footer(PageNames.roomOffer),
      body: CustomScrollView(slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          TagField(
            samples: ConstService.sampleTagsPlay,
            maxTagNumber: 10,
            viewTitle: false,
            initialTags: const [],
            onChanged: (tags) {
              ref.read(waitTimeSearchProvider.notifier).setTags(tags);
            },
          )
        ])),
        WaitTimeList(
          trailingOnTap: trailingOnTap,
          trailingButtonText: '誘う',
        ),
        RecentLoginUserList(
          trailingOnTap: trailingOnTap,
          trailingButtonText: '誘う',
        ),
      ]),
    );
  }
}
