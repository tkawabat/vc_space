import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route.dart';
import '../../entity/user_entity.dart';
import '../../entity/room_entity.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../../provider/login_provider.dart';
import '../../provider/room_list_provider.dart';
import '../../provider/enter_room_stream_provider.dart';
import '../l3/header.dart';
import '../l3/vc_chat.dart';
import '../l1/loading.dart';

class RoomDetailPage extends HookConsumerWidget {
  final String roomId;

  const RoomDetailPage({Key? key, required this.roomId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(enterRoomIdProvider.notifier).set(roomId);
    });

    final roomStream = ref.watch(enterRoomStreamProvider);
    final user = ref.watch(loginUserProvider);

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PageService().transition(PageNames.home);
      });
      return const Loading();
    }

    String title = dotenv.get('TITLE');
    final tabList = ['部屋情報', 'チャット', '参加者'];

    final body = roomStream.when<Widget>(
      loading: () => const Loading(),
      error: (Object error, StackTrace stackTrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          PageService().transition(PageNames.home);
          PageService().snackbar('部屋情報の取得に失敗しました。', SnackBarType.error);
        });
        return const Loading();
      },
      data: (RoomEntity? room) {
        if (room == null) return const Loading();
        // TODO
        // if (!RoomService().isJoined(room, user.uid)) {
        //   ref.read(roomListProvider.notifier).getList();
        //   RoomService().leave();
        //   return const Loading();
        // }

        title = room.title;
        return buildBody(context, ref, room, user);
      },
    );

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
      Column(children: [Expanded(child: VCChat(room: room, user: user))]),
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
