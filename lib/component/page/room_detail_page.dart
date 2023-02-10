import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/enter_room_chat_provider.dart';
import '../../route.dart';
import '../../entity/user_entity.dart';
import '../../entity/room_entity.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../../provider/login_provider.dart';
import '../../provider/enter_room_provider.dart';
import '../l3/header.dart';
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
  }

  @override
  void dispose() {
    super.dispose();
    PageService().ref!.read(enterRoomProvider.notifier).stopUpdate();
    PageService().ref!.read(enterRoomChatProvider.notifier).stopUpdate();
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

    if (!RoomService().isJoined(room, user.uid)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PageService().snackbar('入室していないため、ホーム画面に戻ります。', SnackBarType.error);
        PageService().transition(PageNames.home);
      });
      return const Loading();
    }

    String title = dotenv.get('TITLE');
    Widget body = const Loading();
    if (room != null) {
      title = room.title;
      body = buildBody(context, ref, room, user);
    }

    return DefaultTabController(
        length: tabList.length,
        child: Scaffold(
          appBar: Header(
            title: title,
            bottom:
                TabBar(tabs: tabList.map((text) => Tab(text: text)).toList()),
          ),
          body: body,
        ));
  }

  Widget buildBody(
      BuildContext context, WidgetRef ref, RoomEntity room, UserEntity user) {
    return TabBarView(children: [
      Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('戻る'),
          ),
        ],
      ),
      Column(children: [Expanded(child: VCChat(roomId: room.roomId))]),
      Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('戻る'),
          ),
        ],
      ),
    ]);
  }
}
