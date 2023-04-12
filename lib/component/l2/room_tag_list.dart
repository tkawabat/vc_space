import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/user_entity.dart';
import '../../entity/room_entity.dart';
import '../../service/const_design.dart';
import '../../service/room_service.dart';
import '../../provider/login_user_provider.dart';
import '../l1/tag.dart';

class RoomTagList extends ConsumerWidget {
  final RoomEntity room;
  final bool viewEnterStatus;

  const RoomTagList(this.room, {super.key, this.viewEnterStatus = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserEntity? loginUser = ref.watch(loginUserProvider);

    List<Widget> list = [];

    if (room.roomStatus.value >= RoomStatus.close.value) {
      list.add(Tag(
        text: room.roomStatus.displayName,
        tagColor: Colors.grey.shade400,
      ));
    }

    list.add(Tag(
      text: room.placeType.displayName,
      tagColor: Colors.cyan.shade100,
    ));

    for (final tag in room.tags) {
      list.add(Tag(
        text: tag,
        tagColor: ConstDesign.validTagColor,
        onTap: () {},
      ));
    }

    if (viewEnterStatus &&
        loginUser != null &&
        RoomService().isJoined(room, loginUser.uid)) {
      list.add(Tag(
        text: RoomService()
            .getRoomUser(room, loginUser.uid)!
            .roomUserType
            .displayName,
        tagColor: Colors.orange.shade200,
        bold: true,
      ));
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: list,
    );
  }
}
