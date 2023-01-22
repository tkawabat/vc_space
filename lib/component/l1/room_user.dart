import 'package:flutter/material.dart';
import '../../entity/room_entity.dart';

class RoomUser extends StatelessWidget {
  final RoomEntity room;

  const RoomUser({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 60,
        height: 18,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.person, size: 18),
            Text('${room.users.length}/${room.maxNumber}'),
          ],
        ));
  }
}
