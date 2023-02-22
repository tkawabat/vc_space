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
    bool isHide = roomUser.roomUserType == RoomUserType.offer && !isAdmin;

    return InkWell(
        onTap: isHide
            ? null
            : () => showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) {
                  return UserDialog(
                    uid: roomUser.uid,
                  );
                }),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Card(
              elevation: 4,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: isHide
                        ? const UserIcon()
                        : UserIcon(
                            photo: roomUser.userData.photo,
                            tooltip: roomUser.userData.name,
                          ),
                    title: buildTitle(roomUser, isHide),
                    trailing: buildTrailing(roomUser, isHide),
                  ),
                ],
              ),
            )));
  }

  Widget buildTitle(RoomUserEntity roomUser, bool isHide) {
    return SizedBox(
      width: 250,
      child: Wrap(
        children: [
          Text(isHide ? '' : roomUser.userData.name),
          const SizedBox(width: 10),
          if ([RoomUserType.admin, RoomUserType.offer]
              .contains(roomUser.roomUserType))
            Tag(
              text: roomUser.roomUserType.displayName,
              bold: true,
            )
        ],
      ),
    );
  }

  Widget buildTrailing(RoomUserEntity roomUser, bool isHide) {
    const kickText = '部屋から強制的に脱退させます。\n'
        'キックされたユーザーは、自分から参加することはできません。\n'
        'キックしますか？';

    List<PopupMenuItem> menuList = [];
    if (isAdmin && roomUser.roomUserType == RoomUserType.member) {
      menuList.add(PopupMenuItem(
        onTap: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            PageService().showConfirmDialog(kickText, () {
              RoomService().kick(roomUser);
            });
          });
        },
        child: const Text('キックする'),
      ));
    }
    if (isAdmin && roomUser.roomUserType == RoomUserType.offer) {
      menuList.add(PopupMenuItem(
        onTap: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            RoomService().offerStop(roomUser);
          });
        },
        child: const Text('誘いをやめる'),
      ));
    }

    return SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!isHide)
            Tooltip(
              message: 'Discord名をコピー',
              child: InkWell(
                onTap: () async {
                  final data =
                      ClipboardData(text: roomUser.userData.discordName);
                  Clipboard.setData(data).then((_) {
                    PageService()
                        .snackbar('Discord名をコピーしました', SnackBarType.info);
                  });
                },
                child: const FaIcon(FontAwesomeIcons.discord),
              ),
            ),
          if (menuList.isNotEmpty) const SizedBox(width: 10),
          if (menuList.isNotEmpty)
            PopupMenuButton(
              tooltip: 'メニューを表示',
              itemBuilder: (_) => menuList,
            ),
        ],
      ),
    );
  }
}
