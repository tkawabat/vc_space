import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/room_user_entity.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../dialog/user_dialog.dart';
import '../l1/tag.dart';
import '../l1/user_icon.dart';

class RoomUserCard extends ConsumerWidget {
  final RoomUserEntity roomUser;
  final bool isAdmin;

  const RoomUserCard(this.roomUser, this.isAdmin, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    leading: roomUser.roomUserType == RoomUserType.offer
                        ? const UserIcon()
                        : UserIcon(
                            photo: roomUser.userData.photo,
                            tooltip: roomUser.userData.name,
                          ),
                    title: buildTitle(roomUser),
                    trailing: buildTrailing(roomUser),
                  ),
                ],
              ),
            )));
  }

  Widget buildTitle(RoomUserEntity roomUser) {
    return SizedBox(
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(roomUser.roomUserType == RoomUserType.offer
              ? 'オファー中'
              : roomUser.userData.name),
          if (roomUser.roomUserType == RoomUserType.admin)
            const SizedBox(width: 10),
          if (roomUser.roomUserType == RoomUserType.admin)
            Tag(
              text: roomUser.roomUserType.displayName,
              bold: true,
            )
        ],
      ),
    );
  }

  Widget buildTrailing(RoomUserEntity roomUser) {
    const kickText = '部屋からキックします。\n'
        'キックされたユーザーは、自分から参加することはできません。\n'
        'キックしますか？';

    return SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () async {
              final data = ClipboardData(text: roomUser.userData.discordName);
              Clipboard.setData(data).then((_) {
                PageService().snackbar('Discord名をコピーしました', SnackBarType.info);
              });
            },
            child: const FaIcon(FontAwesomeIcons.discord),
          ),
          if (isAdmin) const SizedBox(width: 10),
          if (isAdmin)
            PopupMenuButton(
              tooltip: 'メニューを表示',
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: roomUser.roomUserType == RoomUserType.admin
                      ? null
                      : () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            PageService().showConfirmDialog(kickText, () {
                              RoomService().kick(roomUser);
                            });
                          });
                        },
                  child: const Text('キックする'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
