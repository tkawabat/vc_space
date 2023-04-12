import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vc_space/entity/room_entity.dart';

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

    final disabledButton = Button(
      color: Theme.of(context).colorScheme.error,
      onTap: null,
      text: '脱退する',
    );

    if (loginUser == null) return disabledButton;
    if (room == null) return disabledButton;

    final roomUser = RoomService().getRoomUser(room, loginUser.uid);
    if (roomUser == null) return disabledButton;

    // member
    if (roomUser.roomUserType != RoomUserType.admin) {
      return Button(
          color: Theme.of(context).colorScheme.error,
          onTap: () {
            PageService().showConfirmDialog('部屋から脱退します', () {
              RoomService().quit(room, loginUser.uid);
              PageService().back();
            });
          },
          text: '脱退する');
    }

    // owner
    if (room.roomStatus == RoomStatus.close) {
      return Button(
          color: Theme.of(context).colorScheme.tertiary,
          onTap: () {
            PageService().showConfirmDialog('メンバーの募集を再開します。', () {
              RoomService().updateStatus(room, RoomStatus.open);
            });
          },
          text: '募集を再開する');
    }
    if (room.roomStatus == RoomStatus.open && room.users.length > 1) {
      return Button(
          color: Theme.of(context).colorScheme.tertiary,
          onTap: () {
            PageService().showConfirmDialog('メンバーの募集を終了します。', () {
              RoomService().updateStatus(room, RoomStatus.close);
            });
          },
          text: '募集を終了する');
    }
    if (room.roomStatus == RoomStatus.open && room.users.length <= 1) {
      return Button(
          color: Theme.of(context).colorScheme.error,
          onTap: () {
            PageService().showConfirmDialog('一度削除した部屋は戻せません。本当に部屋を削除しますか？', () {
              RoomService().delete(room);
            });
          },
          text: '部屋を削除する');
    }

    // イレギュラー
    return disabledButton;
  }
}
