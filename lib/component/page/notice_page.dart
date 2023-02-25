import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route.dart';
import '../../service/page_service.dart';
import '../l3/footer.dart';
import '../l3/header.dart';
import '../l3/notice_list.dart';

class NoticePage extends HookConsumerWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    return Scaffold(
      appBar: const Header(PageNames.notice, 'お知らせ'),
      bottomNavigationBar: const Footer(PageNames.notice),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NoticeList(),
        ],
      ),
    );
  }
}
