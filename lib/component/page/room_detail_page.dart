import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/enter_room_chat_provider.dart';
import '../../provider/enter_room_private_provider.dart';
import '../../route.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../../provider/login_provider.dart';
import '../../provider/enter_room_provider.dart';
import '../l3/footer.dart';
import '../l3/header.dart';
import '../l3/room_page_basic.dart';
import '../l3/room_page_user.dart';
import '../l3/vc_chat.dart';
import '../l1/loading.dart';

class RoomDetailPage extends ConsumerStatefulWidget {
  final int roomId;

  const RoomDetailPage({Key? key, required this.roomId}) : super(key: key);

  @override
  RoomDetailPageState createState() => RoomDetailPageState();
}

class RoomDetailPageState extends ConsumerState<RoomDetailPage> {
  static const tabList = ['部屋情報', 'チャット', '参加者'];

  @override
  void initState() {
    super.initState();
    ref.read(enterRoomProvider.notifier).startUpdate(widget.roomId);
    ref.read(enterRoomChatProvider.notifier).startUpdate(widget.roomId);
    ref.read(enterRoomPrivateProvider.notifier).startUpdate(widget.roomId);
  }

  @override
  void dispose() {
    super.dispose();
    PageService().ref!.read(enterRoomProvider.notifier).stopUpdate();
    PageService().ref!.read(enterRoomChatProvider.notifier).stopUpdate();
    PageService().ref!.read(enterRoomPrivateProvider.notifier).stopUpdate();
  }

  @override
  Widget build(BuildContext context) {
    PageService().init(context, ref);

    final room = ref.watch(enterRoomProvider);
    final user = ref.watch(loginUserProvider);

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PageService().snackbar('未ログインのため、ホーム画面に戻ります。', SnackBarType.error);
        PageService().transition(PageNames.home);
      });
      return const Loading();
    }

    if (room == null) {
      return const Loading();
    }

    if (!RoomService().isCompletelyJoined(room, user.uid)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PageService().snackbar('入室していないため、ホーム画面に戻ります。', SnackBarType.error);
        PageService().transition(PageNames.home);
      });
      return const Loading();
    }

    return DefaultTabController(
        length: tabList.length,
        child: Scaffold(
          appBar: Header(
            PageNames.room,
            room.title,
            bottom: TabBar(
                indicatorColor: Colors.black,
                tabs: tabList.map((text) => Tab(text: text)).toList()),
          ),
          bottomNavigationBar: const Footer(PageNames.room),
          body: TabBarView(children: [
            const RoomPageBasic(),
            VCChat(roomId: room.roomId),
            RoomPageUser(room),
          ]),
        ));
  }
}
