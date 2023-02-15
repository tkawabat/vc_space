import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/room_user_entity.dart';
import '../../provider/login_provider.dart';
import '../dialog/user_dialog.dart';
import '../l1/user_icon.dart';

class RoomUserCard extends ConsumerWidget {
  final RoomUserEntity roomUser;

  const RoomUserCard(this.roomUser, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginUser = ref.watch(loginUserProvider);

    return InkWell(
        onTap: () => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return UserDialog(
                uid: roomUser.uid,
              );
            }),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Card(
              elevation: 8,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: UserIcon(
                      photo: roomUser.userData.photo,
                      tooltip: roomUser.userData.name,
                    ),
                    title: Text(roomUser.userData.name),
                  ),
                ],
              ),
            )));
  }
}
