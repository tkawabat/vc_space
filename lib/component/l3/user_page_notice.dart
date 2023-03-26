import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vc_space/service/user_service.dart';

import '../../entity/user_private_entity.dart';
import '../../provider/login_user_private_provider.dart';
import '../../service/const_design.dart';
import '../l1/button.dart';

class UserPageNotice extends HookConsumerWidget {
  const UserPageNotice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;

    if (size.width > ConstDesign.pcSize) {
      return const SizedBox();
    }

    final UserPrivateEntity? userPrivate = ref.watch(loginUserPrivateProvider);

    if (userPrivate == null) {
      return const SizedBox();
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            const Text('プッシュ通知', style: ConstDesign.h2),
            const SizedBox(height: 16),
            Button(
              alignment: Alignment.center,
              onTap: () {
                UserService().addFcmToken();
              },
              text: 'デバイスを登録',
            ),
            const SizedBox(height: 8),
            Button(
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.error,
              onTap: () {
                UserService().deleteFcmTokens();
              },
              text: 'デバイスをクリア',
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: Text(
                '登録済みデバイス: ${userPrivate.fcmTokens.length}',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'プッシュ通知を使うには"きてね"をホーム画面に追加してください',
              style: ConstDesign.caution,
            ),
          ],
        ));
  }
}
