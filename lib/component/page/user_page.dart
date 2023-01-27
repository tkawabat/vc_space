import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vc_space/service/twitter_service.dart';

import '../../route.dart';
import '../../entity/user_entity.dart';
import '../../provider/login_provider.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';

import '../dialog/user_dialog.dart';
import '../l1/loading.dart';
import '../l1/logout_button.dart';
import '../l1/twitter_link.dart';
import '../l1/user_icon.dart';
import '../l2/tag_field.dart';
import '../l3/header.dart';
import '../l3/user_page_basic.dart';

class UserPage extends HookConsumerWidget {
  UserPage({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormBuilderState>();
  final tagKey = GlobalKey<TagFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    final UserEntity? user = ref.watch(loginUserProvider);
    if (user == null) {
      // 未ログイン表示をする
      Timer(const Duration(microseconds: 1), () {
        PageService().transition(PageNames.home);
      });
      return const Loading();
    }

    return Scaffold(
      appBar: const Header(
        title: "マイページ",
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: UserIcon(
                photo: user.photo,
                tooltip: 'ユーザー情報を見る',
                onTap: () => showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) {
                      return UserDialog(userId: user.id);
                    }),
              ),
              title: Text(user.name),
              trailing: IconButton(
                tooltip: 'Twitter情報を再読み込み',
                icon: const Icon(Icons.sync),
                onPressed: () {
                  PageService()
                      .showConfirmDialog('Twitterで再認証して、名前、アイコン再読み込みする', () {
                    twitterLogin();
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            TwitterLink(user: user),
            const SizedBox(height: 40),
            UserPageBasic(user: user),
            // const Text('基本情報', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 80),
            const Center(child: LogoutButton()),
          ],
        ),
      ),
    );
  }

  FormBuilderField greetingField(String text) {
    const labelText = '自己紹介 (最大${ConstService.userGreetingMax}文字)';

    return FormBuilderTextField(
      name: 'greeting',
      initialValue: text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: '入力してください'),
        FormBuilderValidators.maxLength(ConstService.userGreetingMax),
      ]),
      decoration: const InputDecoration(labelText: labelText),
    );
  }
}
