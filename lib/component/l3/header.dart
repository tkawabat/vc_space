import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route.dart';
import '../../provider/enter_room_stream_provider.dart';
import '../../provider/login_provider.dart';
import '../../service/page_service.dart';
import '../../service/twitter_service.dart';
import '../../entity/user_entity.dart';

import '../l1/user_no_login_icon.dart';
import '../l1/user_icon.dart';

class Header extends HookConsumerWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;

  const Header({Key? key, required this.title, this.bottom}) : super(key: key);

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserEntity? loginUser = ref.watch(loginUserProvider);

    Widget userIcon = UserNoLoginIcon(
      onTap: () {
        PageService().showConfirmDialog('Twitterでログインする', () {
          twitterLogin();
        });
      },
      tooltip: 'Twitterログイン',
    );
    if (loginUser != null) {
      userIcon = UserIcon(
          photo: loginUser.photo,
          tooltip: 'マイページ',
          onTap: () {
            ref.read(enterRoomIdProvider.notifier).set(null);
            PageService().transition(PageNames.user);
          });
    }

    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            ref.read(enterRoomIdProvider.notifier).set(null);
            PageService().transition(PageNames.home);
          }),
      title: Text(title),
      actions: [
        IconButton(
            tooltip: 'カレンダーを表示',
            icon: const Icon(Icons.calendar_month),
            onPressed: loginUser == null
                ? null
                : () {
                    PageService().transition(
                        PageNames.calendar, {'userId': loginUser.id});
                  }),
        IconButton(
            tooltip: '部屋をタグ検索',
            icon: const Icon(Icons.search),
            onPressed: () {}),
        const Padding(padding: EdgeInsets.only(left: 8)),
        userIcon,
        const Padding(padding: EdgeInsets.only(right: 16)),
      ],
      bottom: bottom,
      elevation: 0,
      // backgroundColor: Colors.transparent,
    );
  }
}
