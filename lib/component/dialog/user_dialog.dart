import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/user_entity.dart';
import '../../entity/user_private_entity.dart';
import '../../provider/login_user_private_provider.dart';
import '../../provider/login_user_provider.dart';
import '../../provider/user_list_provider.dart';
import '../../route.dart';
import '../../service/page_service.dart';
import '../../service/time_service.dart';
import '../../service/user_service.dart';
import '../l1/button.dart';
import '../l1/loading.dart';
import '../l1/user_icon.dart';
import '../l2/user_tag_list.dart';

class UserDialog extends HookConsumerWidget {
  final String uid;

  const UserDialog({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(userListProvider.notifier).get(uid);

    final UserEntity? loginUser = ref.watch(loginUserProvider);
    final UserPrivateEntity? loginUserPrivate =
        ref.watch(loginUserPrivateProvider);
    final Map<String, UserEntity> userList = ref.watch(userListProvider);

    UserEntity user = userList[uid] ?? userOnLoad;
    const double width = 400;
    const double height = 300;

    if (userList[uid] == null) {
      return const AlertDialog(
          content: SizedBox(
        width: width,
        height: height,
        child: Loading(),
      ));
    }

    String blockText = 'ブロックする';
    void Function()? blockFunction;
    if (loginUserPrivate == null || loginUserPrivate.uid == user.uid) {
      // 未ログイン or 自分自身 -> skip
    } else if (UserService().isBlocked(loginUserPrivate, user.uid)) {
      blockText = 'ブロック解除する';
      blockFunction = () => UserService().unblock(loginUserPrivate, user.uid);
    } else {
      blockFunction = () => UserService().block(loginUserPrivate, user.uid);
    }

    String followText = 'フォローする';
    void Function()? followFunction;
    Color? followButtonColor;
    if (loginUser == null || loginUser.uid == user.uid) {
      // 未ログイン or 自分自身 -> skip
    } else if (UserService().isFollowed(loginUser, user.uid)) {
      followText = 'フォロー中';
      followButtonColor = Colors.grey;
      followFunction = () => UserService().unfollow(user.uid);
    } else {
      followFunction = () => UserService().follow(loginUser, user.uid);
    }

    return AlertDialog(
      title: ListTile(
        leading: UserIcon(photo: user.photo),
        title: Text(user.name),
        subtitle: Text(TimeService().getAgoString(user.updatedAt)),
        trailing: PopupMenuButton(
          tooltip: 'メニューを表示',
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: blockFunction,
              child: Text(blockText),
            ),
          ],
        ),
      ),
      content: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('プロフィール', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(user.greeting),
            const SizedBox(height: 16),
            const Text('タグ', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              alignment: Alignment.topLeft,
              child: UserTagList(user, viewBlock: true),
            ),
            const SizedBox(height: 16),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    PageService().transition(PageNames.calendar,
                        arguments: {'uid': uid});
                  },
                  icon: const Icon(Icons.calendar_month),
                  label: const Text('予定表'),
                ),
                Button(
                  // alignment: Alignment.bottomRight,
                  onTap: followFunction,
                  text: followText,
                  color: followButtonColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
