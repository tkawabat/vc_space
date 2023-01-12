import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../service/initial_service.dart';
import '../../service/twitter_service.dart';

import '../l3/header.dart';
import '../dialog/confirm_dialog.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({Key? key}) : super(key: key);

  Future<void> showConfirmDialog(BuildContext context, WidgetRef ref) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return ConfirmDialog(
            text: 'ログアウトします',
            onSubmit: () {
              twitterLogout(ref);
              Navigator.pop(context);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    InitialService().init(ref);

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
                showConfirmDialog(context, ref);
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
