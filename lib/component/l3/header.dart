import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route.dart';
import '../../provider/login_user_provider.dart';
import '../../service/login_service.dart';
import '../../service/page_service.dart';
import '../../entity/user_entity.dart';
import '../l1/user_no_login_icon.dart';
import '../l1/user_icon.dart';
import '../l2/notice_badge.dart';

class Header extends HookConsumerWidget implements PreferredSizeWidget {
  final PageNames page;
  final String title;
  final PreferredSizeWidget? bottom;

  const Header(this.page, this.title, {Key? key, this.bottom})
      : super(key: key);

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserEntity? loginUser = ref.watch(loginUserProvider);
    final Size size = MediaQuery.of(context).size;

    Widget userIcon = UserNoLoginIcon(
      onTap: () {
        PageService().showConfirmDialog('Discordでログインする', () {
          LoginService().login();
        });
      },
      tooltip: 'Discordでログイン',
    );
    if (loginUser != null) {
      userIcon = UserIcon(
          photo: loginUser.photo,
          tooltip: 'マイページ',
          onTap: () {
            PageService().transition(PageNames.user);
          });
    }

    List<Widget> actionList = [];
    if (size.width > 700) {
      actionList.add(IconButton(
          tooltip: '予定を作る',
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => PageService().viewCreateDialog(page)));
      actionList.add(IconButton(
          tooltip: '予定表',
          icon: const Icon(Icons.calendar_month),
          onPressed: () => PageService().transitionMyCalendar(page)));
      actionList.add(Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: NoticeBadge(
          child: IconButton(
              tooltip: 'お知らせ',
              icon: const Icon(Icons.notifications),
              onPressed: () => PageService().transitionNotice(page)),
        ),
      ));
    }

    return AppBar(
      centerTitle: false,
      leading: PageService().canBack()
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                PageService().back();
              })
          : null,
      title: Text(title),
      actions: [
        ...actionList,
        const Padding(padding: EdgeInsets.only(left: 16)),
        userIcon,
        const Padding(padding: EdgeInsets.only(right: 16)),
      ],
      bottom: bottom,
      elevation: 0,
    );
  }
}
