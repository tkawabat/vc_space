import 'package:flutter/material.dart';

import '../l4/create_room_dialog.dart';

class CreateRoomButton extends StatelessWidget {
  const CreateRoomButton({super.key});

  Future<void> showCreateRoomDialog(context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return const CreateRoomDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '部屋を作る',
      child: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            showCreateRoomDialog(context);
          }),
    );
  }
}
