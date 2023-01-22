import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../entity/user_entity.dart';
import '../../provider/user_list_provider.dart';
import '../../service/const_design.dart';
import '../l1/tag.dart';
import '../l1/user_icon.dart';

class UserDialog extends HookConsumerWidget {
  final String userId;

  const UserDialog({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(userListProvider.notifier).get(userId);
    final Map<String, UserEntity> userList = ref.watch(userListProvider);

    UserEntity user = userList[userId] ?? userOnLoad;

    // TODO
    // onloadはくるくるを返す

    return AlertDialog(
      title: SizedBox(
        width: 300,
        height: 100,
        child: Column(
          children: [
            Row(children: [
              UserIcon(photo: user.photo),
              Text(user.name),
            ]),
            buildTrailing(user),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              alignment: Alignment.topLeft,
              child: Wrap(
                spacing: 2,
                children: buildTag(user),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTrailing(UserEntity user) {
    DateFormat formatter = DateFormat('M/d(E) HH:mm', "ja_JP");
    String time = formatter.format(user.updatedAt); // N秒前表現

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('最終ログイン: $time'),
        InkWell(
            child: SizedBox(
              width: 40,
              height: 14,
              child: Row(
                children: [
                  const FaIcon(FontAwesomeIcons.twitter,
                      color: Colors.grey, size: 18),
                  Text(user.twitterId),
                ],
              ),
            ),
            onTap: () => {}),
      ],
    );
  }

  List<Widget> buildTag(UserEntity user) {
    List<Widget> widgets = user.tags
        .map((text) => Tag(
              text: text,
              tagColor: ConstDesign.validTagColor,
              onTap: () {},
            ))
        .toList();

    return widgets;
  }
}
