import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/room_entity.dart';
import '../../entity/room_user_entity.dart';
import '../../entity/user_entity.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../../provider/enter_room_provider.dart';
import '../../provider/login_user_provider.dart';
import 'button.dart';

class RoomQuitButton extends ConsumerWidget {
  const RoomQuitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserEntity? loginUser = ref.watch(loginUserProvider);
    final room = ref.read(enterRoomProvider);

    final color = Theme.of(context).colorScheme.error;
    final disabledButton = Button(
      color: color,
      onTap: null,
      text: '脱退する',
    );

    if (loginUser == null) return disabledButton;
    if (room == null) return disabledButton;

    final roomUser = RoomService().getRoomUser(room, loginUser.uid);
    if (roomUser == null) return disabledButton;
    if (roomUser.roomUserType == RoomUserType.admin) {
      return Button(
          color: color,
          onTap: () {
            PageService().showConfirmDialog('一度削除した部屋は戻せません。本当に部屋を削除しますか？', () {
              RoomService().delete(room);
              PageService().back();
            });
          },
          text: '部屋を削除する');
    } else {
      return Button(
          color: color,
          onTap: () {
            PageService().showConfirmDialog('部屋から脱退します。', () {
              RoomService().quit(room, loginUser.uid);
              PageService().back();
            });
          },
          text: '脱退する');
    }
  }
}
