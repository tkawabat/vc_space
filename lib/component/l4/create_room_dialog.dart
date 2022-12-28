import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/room_entity.dart';
import '../../provider/create_room_provider.dart';
import '../../provider/room_list_provider.dart';

class CreateRoomDialog extends ConsumerWidget {
  const CreateRoomDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    // titleController.text = createRoom.title;

    return AlertDialog(
        title: const Text('部屋を作る'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            titleField(titleController),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('キャンセル'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('作成'),
            onPressed: () {
              RoomEntity newRoom = createSampleRoom(titleController.text);

              ref.read(roomListProvider.notifier).add(newRoom);
              ref.read(createRoomProvider.notifier).reset();

              Navigator.pop(context);
            },
          ),
        ]);
  }

  TextFormField titleField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(hintText: "タイトル"),
      maxLengthEnforcement: MaxLengthEnforcement.none, enabled: true,
      // 入力数
      maxLength: 10,
      style: const TextStyle(color: Colors.red),
      maxLines: 1,
    );
  }
}
