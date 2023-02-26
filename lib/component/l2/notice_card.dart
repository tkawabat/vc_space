import 'package:flutter/material.dart';

import '../../entity/notice_entity.dart';
import '../../service/time_service.dart';
import '../dialog/room_dialog.dart';
import '../dialog/user_dialog.dart';
import '../l1/card_base.dart';
import '../l1/user_no_login_icon.dart';
import '../l1/user_icon.dart';

class NoticeCard extends StatelessWidget {
  final NoticeEntity notice;

  const NoticeCard(this.notice, {super.key});

  @override
  Widget build(BuildContext context) {
    String title;
    void Function()? leadingOnTap;
    void Function()? onTap;
    bool noUserIcon = false;

    showUserDialog() => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return UserDialog(
            uid: notice.idUser!,
          );
        });
    showRoomDialog() => showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return RoomDialog(
            room: notice.roomData!,
          );
        });

    switch (notice.noticeType) {
      case NoticeType.followed:
        title = '${notice.userData!.name}さんがあなたをフォローしました。';
        onTap = showUserDialog;
        break;
      case NoticeType.followerCreateRoom:
        title =
            '${notice.userData!.name}さんが部屋"${notice.roomData!.title}"を作りました。';
        onTap = showRoomDialog;
        leadingOnTap = showUserDialog;
        break;
      case NoticeType.roomMemberAdded:
        title =
            '${notice.userData!.name}さんが部屋"${notice.roomData!.title}"に参加しました。';
        onTap = showRoomDialog;
        leadingOnTap = showUserDialog;
        break;
      case NoticeType.roomDeleted:
        title = '部屋"${notice.roomData!.title}"が削除されました。';
        noUserIcon = true;
        break;
      case NoticeType.roomOffered:
        title = '部屋"${notice.roomData!.title}"へのオファーが来ています！';
        onTap = showRoomDialog;
        leadingOnTap = showUserDialog;
        noUserIcon = true;
        break;
      case NoticeType.roomKicked:
        title = '部屋"${notice.roomData!.title}"からキックされました。';
        noUserIcon = true;
        break;
    }

    Widget leading = noUserIcon
        ? UserNoLoginIcon(onTap: leadingOnTap)
        : UserIcon(photo: notice.userData!.photo, onTap: leadingOnTap);

    return CardBase(
      onTap: onTap,
      children: [
        ListTile(
          leading: leading,
          title: Wrap(children: [Text(title)]),
          subtitle: Text(TimeService().getAgoString(notice.createdAt)),
        )
      ],
    );
  }
}
