import 'package:flutter/material.dart';

import '../../entity/user_entity.dart';

class UserNotificationBadge extends StatelessWidget {
  final UserEntity user;

  const UserNotificationBadge(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    if (!user.push) {
      return const SizedBox();
    }

    return Tooltip(
      message: 'プッシュ通知設定済み',
      child: Icon(
        Icons.notifications,
        size: 18,
        color: Colors.yellow[700],
      ),
    );
  }
}
