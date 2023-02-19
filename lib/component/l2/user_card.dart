import 'package:flutter/material.dart';

import '../../entity/user_entity.dart';
import '../dialog/user_dialog.dart';
import '../../service/time_service.dart';
import '../l1/button.dart';
import '../l1/user_icon.dart';
import 'user_tag_list.dart';

class UserCard extends StatelessWidget {
  final UserEntity user;
  final void Function()? trailingOnTap;
  final String? trailingButtonText;

  const UserCard(
    this.user, {
    super.key,
    this.trailingOnTap,
    this.trailingButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) {
              return UserDialog(
                uid: user.uid,
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
                      photo: user.photo,
                      tooltip: user.name,
                    ),
                    title: Wrap(children: [
                      Text(user.name),
                      UserTagList(user),
                    ]),
                    subtitle: Text(TimeService().getAgoString(user.updatedAt)),
                    trailing: trailingButtonText != null
                        ? SizedBox(
                            width: 70,
                            child: Button(
                              onTap: trailingOnTap,
                              text: trailingButtonText!,
                            ),
                          )
                        : null,
                  ),
                  // Container(
                  //   padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                  //   alignment: Alignment.topLeft,
                  //   child: UserTagList(user),
                  // ),
                ],
              ),
            )));
  }
}
