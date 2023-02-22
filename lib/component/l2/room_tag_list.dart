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

    List<Widget> widgets = room.tags
        .map((text) => Tag(
              text: text,
              tagColor: ConstDesign.validTagColor,
              onTap: () {},
            ))
        .toList();

    widgets.insert(
        0,
        Tag(
          text: room.placeType.displayName,
          tagColor: Colors.cyan.shade100,
        ));

    if (viewEnterStatus &&
        loginUser != null &&
        RoomService().isJoined(room, loginUser.uid)) {
      widgets.add(Tag(
        text: RoomService()
            .getRoomUser(room, loginUser.uid)!
            .roomUserType
            .displayName,
        tagColor: Colors.orange.shade200,
        bold: true,
      ));
    }

    return Wrap(spacing: 2, children: widgets);
  }
}
