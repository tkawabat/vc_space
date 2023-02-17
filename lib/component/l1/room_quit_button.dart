import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/room_entity.dart';
import '../../entity/room_user_entity.dart';
import '../../entity/user_entity.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../../provider/enter_room_provider.dart';
import '../../provider/login_provider.dart';
import 'button.dart';

class RoomQuitButton extends ConsumerWidget {
  const RoomQuitButton({super.key});

  bool canQuit(RoomEntity? room, UserEntity? user) {
    if (user == null) return false;
    if (room == null) return false;

    final roomUser = RoomService().getOwnRoomUser(room, user.uid);
    if (roomUser == null) return false;
    if (roomUser.roomUserType == RoomUserType.admin) return false;

    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserEntity? loginUser = ref.watch(loginUserProvider);
    final room = ref.read(enterRoomProvider);

    return Button(
      color: Theme.of(context).colorScheme.error,
      onTap: canQuit(room, loginUser)
          ? () {
              PageService().showConfirmDialog('部屋から脱退します。', () {
                RoomService().quit(room!, loginUser!.uid);
                PageService().back();
              });
            }
          : null,
      text: '脱退する',
    );
  }
}
