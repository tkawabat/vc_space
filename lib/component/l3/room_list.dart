import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/login_provider.dart';
import '../../provider/room_list_provider.dart';
import '../l2/room_card.dart';

class RoomList extends ConsumerWidget {
  const RoomList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomList = ref.watch(roomListProvider);
    final user = ref.watch(loginUserProvider);

    final scrollController = ScrollController();

    final list =
        roomList.map((room) => RoomCard(room: room, user: user)).toList();

    return Flexible(
      child: Scrollbar(
        controller: scrollController,
        child: ListView(
          controller: scrollController,
          children: list,
        ),
      ),
    );
  }
}
