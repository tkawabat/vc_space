import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route.dart';
import '../../provider/login_user_provider.dart';
import '../../service/const_design.dart';
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
    if (size.width > ConstDesign.pcSize) {
      actionList.add(IconButton(
          tooltip: '誘って',
          icon: const Icon(Icons.add_circle_outline, color: Colors.black54),
          onPressed: () => PageService().viewCreateWaitTimeDialog()));
      actionList.add(IconButton(
          tooltip: '予定表',
          icon: const Icon(Icons.calendar_month, color: Colors.black54),
          onPressed: () => PageService().transitionMyCalendar(page)));
      actionList.add(IconButton(
          tooltip: '待ちリスト',
          icon: const Icon(Icons.person, color: Colors.black54),
          onPressed: () => PageService().transitionCalendarWait(page)));
      actionList.add(Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: NoticeBadge(
          child: IconButton(
              tooltip: 'お知らせ',
              icon: const Icon(Icons.notifications, color: Colors.black54),
              onPressed: () => PageService().transitionNotice(page)),
        ),
      ));
    }

    const canBackPages = [
      PageNames.userPastRoom,
      PageNames.userFollow,
      PageNames.userFollower,
      PageNames.roomOffer,
    ];

    return AppBar(
      centerTitle: false,
      // フォローボタンの押下、クエリパラメータ付きアクセスで予期せぬcanBack()=trueが発生する
      leading: PageService().canBack() && canBackPages.contains(page)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black54),
              onPressed: () {
                PageService().back();
              })
          : IconButton(
              icon: const Icon(Icons.home, color: Colors.black54),
              onPressed: () {
                PageService().transition(PageNames.home);
              }),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      actions: [
        ...actionList,
        const Padding(padding: EdgeInsets.only(left: 16)),
        userIcon,
        const Padding(padding: EdgeInsets.only(right: 16)),
      ],
      bottom: bottom,
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }
}
