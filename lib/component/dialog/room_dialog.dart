import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../entity/room_entity.dart';
import '../../entity/user_entity.dart';
import '../../service/room_service.dart';
import '../l1/cancel_button.dart';
import '../l1/room_user_number.dart';
import '../l2/room_tag_list.dart';

class RoomDialog extends StatelessWidget {
  final RoomEntity room;
  final UserEntity? user;

  const RoomDialog({super.key, required this.room, required this.user});

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('M/d(E) HH:mm', "ja_JP");
    String start = '${formatter.format(room.startTime)}〜';

    final description = room.description.isNotEmpty
        ? Text(room.description)
        : const Text('部屋説明無し', style: TextStyle(color: Colors.black54));

    final List<Widget> list = [
      const Text('基本情報', style: TextStyle(fontWeight: FontWeight.w700)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(start, textAlign: TextAlign.start),
          RoomUserNumber(room: room),
        ],
      ),
      const Text('部屋説明', style: TextStyle(fontWeight: FontWeight.w700)),
      description,
      const Text('タグ', style: TextStyle(fontWeight: FontWeight.w700)),
      RoomTagList(room: room, user: user),
    ];

    // TODO
    String buttonText = '入室する';
    // String buttonText =
    //     RoomService().isJoined(room, user?.uid ?? '') ? '入室する' : '参加する';

    return AlertDialog(
      title: Text(room.title),
      content: SizedBox(
        width: 400,
        height: 400,
        child: ListView.separated(
          itemCount: list.length,
          itemBuilder: (context, i) => list[i],
          separatorBuilder: (context, i) => const SizedBox(height: 16),
        ),
      ),
      actions: [
        const CancelButton(),
        TextButton(
          onPressed: user == null
              ? null
              : () {
                  Navigator.pop(context);
                  RoomService().join(room, user!);
                },
          child: Text(buttonText),
        ),
      ],
    );
  }
}
