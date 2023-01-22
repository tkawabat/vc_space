import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../entity/room_entity.dart';
import '../../service/room_service.dart';
import '../l1/cancel_button.dart';
import '../l1/room_user.dart';
import '../l2/room_tag_list.dart';

class RoomDialog extends StatelessWidget {
  final RoomEntity room;
  final String? userId;

  const RoomDialog({super.key, required this.room, required this.userId});

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('M/d(E) HH:mm', "ja_JP");
    String start = formatter.format(room.startTime);

    final description = room.description.isNotEmpty
        ? Text(room.description)
        : const Text('部屋説明無し', style: TextStyle(color: Colors.black54));

    final List<Widget> list = [
      const Text('基本情報', style: TextStyle(fontWeight: FontWeight.w700)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            start,
            textAlign: TextAlign.start,
          ),
          RoomUser(room: room),
        ],
      ),
      const Text('部屋説明', style: TextStyle(fontWeight: FontWeight.w700)),
      description,
      const Text('タグ', style: TextStyle(fontWeight: FontWeight.w700)),
      RoomTagList(room: room),
      // RoomCard(room: room, userId: userId),
    ];

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
            child: const Text('入室する'),
            onPressed: () {
              if (userId == null) {
              } else {
                RoomService().enter(room.id, userId!);
              }
            }),
      ],
    );
  }
}
