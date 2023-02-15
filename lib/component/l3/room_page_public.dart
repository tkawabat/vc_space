import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vc_space/component/dialog/room_create_dialog.dart';

import '../../provider/enter_room_provider.dart';
import '../../provider/login_provider.dart';
import '../../service/const_service.dart';

import '../../service/page_service.dart';
import '../l1/loading.dart';

class RoomPagePublic extends HookConsumerWidget {
  const RoomPagePublic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loginUserProvider);
    final room = ref.watch(enterRoomProvider);

    if (user == null || room == null) {
      return const Loading();
    }

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
                        return RoomCreateDialog();
                      })),
          ],
        ),
        const SizedBox(height: 8),
        const SizedBox(height: 16),
        const SizedBox(height: 24),
      ],
    );
  }
}
