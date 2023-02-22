import 'package:flutter/material.dart';

import '../../route.dart';
import '../../service/page_service.dart';

class FooterItem {
  final IconData icon;
  final String label;
  final PageNames page;
  final void Function() onTap;

  FooterItem(this.icon, this.label, this.page, this.onTap);
}

class Footer extends StatelessWidget {
  final PageNames page;

  const Footer(this.page, {super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width > 700) return const SizedBox();

    final List<FooterItem> list = [
      FooterItem(Icons.home, 'ホーム', PageNames.home,
          () => PageService().transitionHome(page)),
      FooterItem(Icons.notifications, 'お知らせ', PageNames.notice,
          () => PageService().transitionNotice(page)),
      FooterItem(Icons.calendar_month, '予定表', PageNames.calendar,
          () => PageService().transitionMyCalendar(page)),
      FooterItem(Icons.add, '予定を作る', PageNames.none,
          () => PageService().viewCreateDialog(page)),
    ];

    final int currentIndex = list.indexWhere((element) => element.page == page);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (i) => list[i].onTap(),
      items: list
          .map((e) => BottomNavigationBarItem(
                icon: Icon(e.icon),
                label: e.label,
              ))
          .toList(),
      currentIndex: currentIndex < 0 ? 0 : currentIndex,
    );
  }
}
