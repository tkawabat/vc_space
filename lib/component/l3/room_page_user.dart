import 'package:flutter/material.dart';

import '../../entity/room_entity.dart';
import '../l2/room_user_card.dart';

class RoomPageUser extends StatelessWidget {
  final RoomEntity room;

  const RoomPageUser(this.room, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    List<Widget> list = room.users.map((e) => RoomUserCard(e)).toList();
    for (var i = 0; i < 30; i++) {
      list.add(RoomUserCard(room.users[0]));
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ListView(
          controller: scrollController,
          children: list,
        ));
  }
}
