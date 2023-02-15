import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../provider/enter_room_provider.dart';
import '../../provider/login_provider.dart';
import '../../service/const_design.dart';
import '../dialog/room_edit_dialog.dart';
import '../l1/room_user_number.dart';
import '../l1/loading.dart';
import '../l2/room_tag_list.dart';

class RoomPagePublic extends HookConsumerWidget {
  const RoomPagePublic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loginUserProvider);
    final room = ref.watch(enterRoomProvider);

    if (user == null || room == null) {
      return const Loading();
    }

    DateFormat formatter = DateFormat('M/d(E) HH:mm', "ja_JP");
    String start = '${formatter.format(room.startTime)}〜';

    final description = room.description.isNotEmpty
        ? Text(room.description)
        : const Text('部屋説明無し', style: TextStyle(color: Colors.black54));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('公開情報', style: ConstDesign.h2),
            if (user.uid == room.owner)
              IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) {
                        return RoomEditDialog(room: room);
                      })),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('基本情報', style: ConstDesign.h3),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(start, textAlign: TextAlign.start),
                  RoomUserNumber(room: room),
                ],
              ),
              const SizedBox(height: 2),
              Text('入室制限: ${room.enterType.displayName}'),
              const SizedBox(height: 16),
              const Text('部屋説明', style: ConstDesign.h3),
              const SizedBox(height: 8),
              description,
              const SizedBox(height: 16),
              const Text('タグ', style: ConstDesign.h3),
              const SizedBox(height: 8),
              RoomTagList(room, viewEnterStatus: false),
            ],
          ),
        )
      ],
    );
  }
}
