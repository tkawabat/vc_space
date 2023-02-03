import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/user_entity.dart';
import '../../provider/user_list_provider.dart';
import '../../service/const_design.dart';
import '../../service/time_service.dart';
import '../l1/loading.dart';
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
    const double width = 400;
    const double height = 350;

    if (userList[userId] == null) {
      return const AlertDialog(
          content: SizedBox(
        width: width,
        height: height,
        child: Loading(),
      ));
    }

    final List<Widget> list = [
      const Text('自己紹介', style: TextStyle(fontWeight: FontWeight.bold)),
      Text(user.greeting),
      // const SizedBox(height: 20),
      const Text('タグ', style: TextStyle(fontWeight: FontWeight.bold)),
      Container(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
        alignment: Alignment.topLeft,
        child: Wrap(
          spacing: 2,
          children: buildTag(user),
        ),
      )
    ];

    return AlertDialog(
      title: ListTile(
        leading: UserIcon(photo: user.photo),
        title: Text(user.name),
        subtitle: Text('最終ログイン: ${TimeService().getAgoString(user.updatedAt)}'),
      ),
      content: SizedBox(
        width: width,
        height: height,
        child: ListView.separated(
          itemCount: list.length,
          itemBuilder: (context, i) => list[i],
          separatorBuilder: (context, i) => const SizedBox(height: 8),
        ),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [

        //   ],
        // ),
      ),
    );
  }

  List<Widget> buildTag(UserEntity user) {
    if (user.tags.isEmpty) {
      return [const Tag(text: 'なし')];
    }

    List<Widget> widgets = user.tags
        .map((text) => Tag(
              text: text,
              tagColor: ConstDesign.validTagColor,
            ))
        .toList();

    return widgets;
  }
}
