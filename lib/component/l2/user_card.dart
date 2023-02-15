import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/user_entity.dart';
import '../../provider/login_provider.dart';
import '../dialog/user_dialog.dart';
import '../l1/user_icon.dart';
import 'user_tag_list.dart';

class UserCard extends ConsumerWidget {
  final UserEntity user;

  const UserCard(this.user, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginUser = ref.watch(loginUserProvider);

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
                    title: Text(user.name),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                    alignment: Alignment.topLeft,
                    child: UserTagList(user),
                  ),
                ],
              ),
            )));
  }
}
