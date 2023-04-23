import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/enter_room_provider.dart';
import '../../route.dart';
import '../../service/page_service.dart';
import '../dialog/user_search_dialog.dart';
import '../l3/footer.dart';
import '../l3/header.dart';
import '../l3/room_offer_user_list.dart';

class RoomOfferPage extends HookConsumerWidget {
  const RoomOfferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);
    final room = ref.watch(enterRoomProvider);

    return Scaffold(
      appBar: const Header(PageNames.roomOffer, '待ちリスト'),
      bottomNavigationBar: const Footer(PageNames.roomOffer),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoomOfferUserList(room),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: '条件変更',
          onPressed: () => showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => UserSearchDialog()),
          child: const Icon(Icons.search)),
    );
  }
}
