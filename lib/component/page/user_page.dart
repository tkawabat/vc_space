import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/user_entity.dart';
import '../../provider/login_provider.dart';
import '../../service/page_service.dart';
import '../../service/twitter_service.dart';

import '../l3/header.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    final UserEntity? loginUser = ref.watch(loginUserProvider);
    if (loginUser == null) {
      // 未ログイン表示をする
    }

    return Scaffold(
      appBar: const Header(
        title: "マイページ",
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                PageService().showConfirmDialog('ログアウトする', () {
                  twitterLogout(ref);
                  PageService().back();
                });
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.red)),
              child: const Text('ログアウト'),
            ),
          ],
        ),
      ),
    );
  }
}
