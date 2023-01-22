import 'package:flutter/material.dart';

import '../../entity/room_entity.dart';
import '../../service/const_design.dart';
import '../l1/tag.dart';

class RoomTagList extends StatelessWidget {
  final RoomEntity room;

  const RoomTagList({super.key, required this.room});

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
          text: room.place.displayName,
          tagColor: Colors.cyan.shade100,
          onTap: () {},
        ));

    return Wrap(spacing: 2, children: widgets);
  }
}
