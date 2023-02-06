import 'package:flutter/material.dart';

import '../../entity/room_entity.dart';
import '../../entity/user_entity.dart';
import '../../service/const_design.dart';
import '../../service/room_service.dart';
import '../l1/tag.dart';

class RoomTagList extends StatelessWidget {
  final RoomEntity room;
  final UserEntity? user;

  const RoomTagList({super.key, required this.room, required this.user});

  @override
  Widget build(BuildContext context) {
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

    if (user != null && RoomService().isJoined(room, user!.uid)) {
      widgets.add(const Tag(
        text: '参加済み',
        tagColor: Colors.cyan,
        bold: true,
      ));
    }

    return Wrap(spacing: 2, children: widgets);
  }
}
