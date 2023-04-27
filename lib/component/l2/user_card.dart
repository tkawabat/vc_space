import 'package:flutter/material.dart';

import '../../entity/user_entity.dart';
import '../dialog/user_dialog.dart';
import '../../service/time_service.dart';
import '../l1/button.dart';
import '../l1/card_base.dart';
import '../l1/user_icon.dart';
import 'user_tag_list.dart';

class UserCard extends StatelessWidget {
  final UserEntity user;
  final void Function(UserEntity user)? trailingOnTap;
  final String? trailingButtonText;
  final Widget? body;

  const UserCard(
    this.user, {
    super.key,
    this.trailingOnTap,
    this.trailingButtonText,
    this.body,
  });

  @override
  Widget build(BuildContext context) {
    return CardBase(
      onTap: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) {
            return UserDialog(
              uid: user.uid,
            );
          }),
      children: [
        ListTile(
          leading: UserIcon(
            photo: user.photo,
            tooltip: user.name,
          ),
          title: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(user.name),
              UserTagList(user),
            ],
          ),
          subtitle: Text(TimeService().getAgoString(user.updatedAt)),
          trailing: trailingButtonText != null
              ? SizedBox(
                  width: 70,
                  child: Button(
                    onTap: trailingOnTap == null
                        ? null
                        : () => trailingOnTap!(user),
                    text: trailingButtonText!,
                  ),
                )
              : null,
        ),
        body ?? const SizedBox()
      ],
    );
  }
}
