import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../entity/room_entity.dart';
import '../../provider/login_provider.dart';
import '../../service/room_service.dart';
import '../dialog/room_dialog.dart';
import '../dialog/user_dialog.dart';
import '../l1/room_user_number.dart';
import '../l1/user_icon.dart';
import 'room_tag_list.dart';
import 'room_user_row.dart';

class RoomCard extends ConsumerWidget {
  final RoomEntity room;

  const RoomCard(this.room, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loginUserProvider);

    return InkWell(
        onTap: () => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return RoomDialog(
                room: room,
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
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    alignment: Alignment.topLeft,
                    child: RoomUserRow(room, hideAdmin: true),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                    alignment: Alignment.topLeft,
                    child: RoomTagList(room: room, user: user),
                  ),
                ],
              ),
            )));
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
