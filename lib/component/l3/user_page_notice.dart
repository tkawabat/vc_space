import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import '../../entity/user_private_entity.dart';
import '../../provider/login_user_private_provider.dart';
import '../../service/const_design.dart';
import '../../service/user_service.dart';
import '../l1/button.dart';

class UserPageNotice extends HookConsumerWidget {
  const UserPageNotice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPwa = window.matchMedia('(display-mode: standalone)').matches;

    final UserPrivateEntity? userPrivate = ref.watch(loginUserPrivateProvider);

    if (userPrivate == null) {
      return const SizedBox();
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 2),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('プッシュ通知', style: ConstDesign.h2),
            ),
            const SizedBox(height: 16),
            Button(
              alignment: Alignment.center,
              onTap: isPwa
                  ? () {
                      UserService().addFcmToken();
                    }
                  : null,
              text: 'デバイスを登録',
            ),
            const SizedBox(height: 8),
            Button(
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.tertiary,
              onTap: () {
                UserService().deleteFcmTokens();
              },
              text: 'デバイスをクリア',
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: Text(
                '登録済みデバイス: ${userPrivate.fcmTokens.length}',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            if (!isPwa)
              Text(
                'プッシュ通知を使うにはスマートフォンで"きてね"をホーム画面に追加してください',
                style: ConstDesign.caution
                    .copyWith(color: Theme.of(context).colorScheme.error),
              ),
          ],
        ));
  }
}
