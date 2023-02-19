import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/enter_room_provider.dart';
import '../../route.dart';
import '../../service/page_service.dart';
import '../l1/loading.dart';
import '../l3/header.dart';
import '../l3/room_offer_user_list.dart';

class RoomOfferPage extends HookConsumerWidget {
  const RoomOfferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);
    final room = ref.watch(enterRoomProvider);

    if (room == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PageService().snackbar('エラーのため、ホーム画面に戻ります。', SnackBarType.error);
        PageService().transition(PageNames.home);
      });
      return const Loading();
    }

    return Scaffold(
      appBar: const Header(title: '部屋に誘う'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RoomOfferUserList(room),
        ],
      ),
    );
  }
}
