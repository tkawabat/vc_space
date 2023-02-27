import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../provider/enter_room_provider.dart';
import '../l1/loading.dart';
import '../l1/room_quit_button.dart';
import '../l1/twitter_share_icon.dart';
import 'room_page_private.dart';
import 'room_page_public.dart';

class RoomPageBasic extends ConsumerWidget {
  const RoomPageBasic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final room = ref.watch(enterRoomProvider);

    if (room == null) {
      return const Loading();
    }

    DateFormat formatter = DateFormat('M/d(E) HH:mm', "ja_JP");
    String start = '${formatter.format(room.startTime)}〜';
    final shareText = '誰かきてね！\n『${room.title}』\n$start\n';

    return Center(
      child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TwitterShareIcon(
                    text: shareText,
                    url: '?roomId=${room.roomId}',
                    hashtags: room.tags.isEmpty ? [] : [room.tags[0]],
                  ),
                ),
                const RoomPagePrivate(),
                const SizedBox(height: 24),
                const RoomPagePublic(),
                const SizedBox(height: 48),
                const RoomQuitButton(),
              ],
            ),
          )),
    );
  }
}
