import 'package:flutter/material.dart';

import '../../route.dart';
import '../../service/page_service.dart';
import '../l2/notice_badge.dart';

class FooterItem {
  final Widget icon;
  final String label;
  final PageNames page;
  final void Function() onTap;

  FooterItem({
    required this.icon,
    required this.label,
    required this.page,
    required this.onTap,
  });
}

class Footer extends StatelessWidget {
  final PageNames page;

  const Footer(this.page, {super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width > 700) return const SizedBox();

    final List<FooterItem> list = [
      FooterItem(
        icon: const Icon(Icons.home),
        label: 'ホーム',
        page: PageNames.home,
        onTap: () => PageService().transitionHome(page),
      ),
      FooterItem(
        icon: const NoticeBadge(
          alignment: AlignmentDirectional.topStart,
          child: Icon(Icons.notifications),
        ),
        label: 'お知らせ',
        page: PageNames.notice,
        onTap: () => PageService().transitionNotice(page),
      ),
      FooterItem(
        icon: const Icon(Icons.add),
        label: '部屋を作る',
        page: PageNames.none,
        onTap: () => PageService().viewCreateDialog(page),
      ),
      FooterItem(
        icon: const Icon(Icons.calendar_month),
        label: '予定表',
        page: PageNames.calendar,
        onTap: () => PageService().transitionMyCalendar(page),
      ),
      FooterItem(
        icon: const Icon(Icons.analytics),
        label: 'タグ分析',
        page: PageNames.analyticsTag,
        onTap: () => PageService().transitionAnalyticsTag(page),
      ),
    ];

    final int currentIndex = list.indexWhere((element) => element.page == page);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (i) => list[i].onTap(),
      items: list
          .map((e) => BottomNavigationBarItem(
                icon: e.icon,
                label: e.label,
              ))
          .toList(),
      currentIndex: currentIndex < 0 ? 0 : currentIndex,
    );
  }
}
