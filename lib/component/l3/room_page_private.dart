import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../entity/room_private_entity.dart';
import '../../provider/enter_room_private_provider.dart';
import '../../provider/enter_room_provider.dart';
import '../../provider/login_provider.dart';
import '../../service/const_service.dart';

import '../../service/page_service.dart';
import '../dialog/room_private_edit_dialog.dart';
import '../l1/loading.dart';

class RoomPagePrivate extends HookConsumerWidget {
  const RoomPagePrivate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loginUserProvider);
    final room = ref.watch(enterRoomProvider);
    final roomPrivate = ref.watch(enterRoomPrivateProvider);

    if (user == null || room == null || roomPrivate == null) {
      return const Loading();
    }

    // final url = roomPrivate.placeUrl

    final description = roomPrivate.innerDescription.isNotEmpty
        ? Text(roomPrivate.innerDescription)
        : const Text('説明無し', style: TextStyle(color: Colors.black54));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('入室者限定情報',
                style: TextStyle(fontWeight: FontWeight.bold)),
            if (user.uid == room.owner)
              IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (_) {
                        return RoomPrivateEditDialog(roomPrivate);
                      })),
          ],
        ),
        const SizedBox(height: 8),
        description,
        const SizedBox(height: 16),
        description,
        const SizedBox(height: 24),
      ],
    );
  }
}
