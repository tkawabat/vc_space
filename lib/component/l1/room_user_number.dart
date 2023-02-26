import 'package:flutter/material.dart';
import '../../entity/room_entity.dart';

class RoomUserNumber extends StatelessWidget {
  final RoomEntity room;

  const RoomUserNumber({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    Widget enterTypeIcon = const SizedBox();
    if (room.enterType == EnterType.password) {
      enterTypeIcon = Tooltip(
        message: room.enterType.displayName,
        child: const Icon(Icons.lock_outline, size: 18),
      );
    }
    if (room.enterType == EnterType.follow) {
      enterTypeIcon = Tooltip(
        message: room.enterType.displayName,
        child: const Icon(Icons.favorite_outline, size: 18),
      );
    }

    return SizedBox(
        width: 80,
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            enterTypeIcon,
            const Icon(Icons.person, size: 18),
            Text('${room.users.length}/${room.maxNumber}'),
          ],
        ));
  }
}
