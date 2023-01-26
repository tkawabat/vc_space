import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../service/page_service.dart';
import '../../service/twitter_service.dart';

class LogoutButton extends HookConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        PageService().showConfirmDialog('ログアウトする', () {
          twitterLogout(ref);
          PageService().back();
        });
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
      child: const Text('ログアウト'),
    );
  }
}
