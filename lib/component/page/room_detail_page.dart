import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/room_entity.dart';
import '../l3/header.dart';

class RoomDetailPage extends HookConsumerWidget {
  const RoomDetailPage({Key? key, required this.room}) : super(key: key);

  final RoomEntity room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: Header(
        title: room.title,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('戻る'),
            ),
          ],
        ),
      ),
    );
  }
}
