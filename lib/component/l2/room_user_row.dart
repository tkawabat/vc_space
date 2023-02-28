import 'package:flutter/material.dart';

import '../../entity/room_user_entity.dart';
import '../../entity/room_entity.dart';
import '../dialog/user_dialog.dart';
import '../l1/user_icon.dart';
import '../l1/user_no_login_icon.dart';

class RoomUserRow extends StatelessWidget {
  final RoomEntity room;
  final bool hideAdmin;

  const RoomUserRow(this.room, {super.key, this.hideAdmin = false});

  @override
  Widget build(BuildContext context) {
    final List<Widget> list = [];
    for (final roomUser in room.users) {
      if (hideAdmin && roomUser.roomUserType == RoomUserType.admin) continue;
      list.add(roomUser.roomUserType == RoomUserType.offer
          ? const UserNoLoginIcon(tooltip: 'お誘い中')
          : UserIcon(
              photo: roomUser.userData.photo,
              tooltip: roomUser.userData.name,
              onTap: () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) {
                    return UserDialog(uid: roomUser.uid);
                  }),
            ));
    }

    return Row(children: list);
  }
}
