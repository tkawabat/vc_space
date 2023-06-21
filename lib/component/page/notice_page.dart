import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../route.dart';
import '../../service/page_service.dart';
import '../../service/user_service.dart';
import '../l3/footer.dart';
import '../l3/header.dart';
import '../l3/notice_list.dart';

class NoticePage extends HookConsumerWidget {
  const NoticePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserService().readNotice();
    });

    return const Scaffold(
      appBar: Header(PageNames.notice, 'お知らせ'),
      bottomNavigationBar: Footer(PageNames.notice),
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
