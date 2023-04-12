import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../entity/room_entity.dart';
import '../../service/room_service.dart';
import '../dialog/room_dialog.dart';
import '../dialog/user_dialog.dart';
import '../l1/card_base.dart';
import '../l1/room_user_number.dart';
import '../l1/user_icon.dart';
import 'room_tag_list.dart';
import 'room_user_row.dart';

class RoomCard extends StatelessWidget {
  final RoomEntity room;

  const RoomCard(this.room, {super.key});

  @override
  Widget build(BuildContext context) {
    return CardBase(
      color: RoomService().isEnd(room) ? Colors.grey.shade200 : null,
      onTap: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) {
            return RoomDialog(
              room: room,
            );
          }),
      children: [
        ListTile(
          leading: UserIcon(
            photo: RoomService().getAdminUser(room).userData.photo,
            tooltip: '主催者を見る',
            onTap: () => showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) {
                  return UserDialog(uid: room.owner);
                }),
          ),
          title: Text(room.title),
          trailing: buildTrailing(room),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
          alignment: Alignment.topLeft,
          child: RoomUserRow(room, hideAdmin: true),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(4, 2, 4, 8),
          alignment: Alignment.topLeft,
          child: RoomTagList(room),
        ),
      ],
    );
  }

  Widget buildTrailing(room) {
    DateFormat formatter = DateFormat('M/d(E) HH:mm', 'ja_JP');
    String start = formatter.format(room.startTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('$start~'),
        RoomUserNumber(room: room),
      ],
    );
  }
}
