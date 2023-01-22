import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vc_space/component/l1/room_user.dart';

import '../../entity/room_entity.dart';

import '../dialog/room_dialog.dart';
import '../dialog/user_dialog.dart';
import '../l1/user_icon.dart';
import 'room_tag_list.dart';

class RoomCard extends StatelessWidget {
  final RoomEntity room;
  final String? userId;

  const RoomCard({super.key, required this.room, required this.userId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return RoomDialog(
                room: room,
                userId: userId,
              );
            }),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Card(
              elevation: 8,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: UserIcon(
                      photo: room.ownerImage,
                      tooltip: '主催者を見る',
                      onTap: () => showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) {
                            return UserDialog(userId: room.ownerId);
                          }),
                    ),
                    title: Text(room.title),
                    trailing: buildTrailing(room),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                    alignment: Alignment.topLeft,
                    child: RoomTagList(room: room),
                  )
                ],
              ),
            )));
  }

  Widget buildTrailing(room) {
    DateFormat formatter = DateFormat('M/d(E) HH:mm', "ja_JP");
    String start = formatter.format(room.startTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('$start~'),
        RoomUser(room: room),
      ],
    );
  }
}
