import 'package:flutter/material.dart';

import '../l1/room_quit_button.dart';
import 'room_page_private.dart';
import 'room_page_public.dart';

class RoomPageBasic extends StatelessWidget {
  const RoomPageBasic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                RoomPagePrivate(),
                SizedBox(height: 24),
                RoomPagePublic(),
                SizedBox(height: 48),
                RoomQuitButton(),
              ],
            ),
          )),
    );
  }
}
