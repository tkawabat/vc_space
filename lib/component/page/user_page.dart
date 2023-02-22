import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../route.dart';
import '../../entity/user_entity.dart';
import '../../provider/login_user_provider.dart';
import '../../service/const_service.dart';
import '../../service/login_service.dart';
import '../../service/page_service.dart';

import '../dialog/user_dialog.dart';
import '../l1/button.dart';
import '../l1/loading.dart';
import '../l1/user_icon.dart';
import '../l2/tag_field.dart';
import '../l3/footer.dart';
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PageService().transition(PageNames.home);
      });
      return const Loading();
    }

    return Scaffold(
      appBar: const Header(PageNames.user, "マイページ"),
      bottomNavigationBar: const Footer(PageNames.user),
      body: Container(
        padding: const EdgeInsets.all(16),
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
                      return UserDialog(uid: user.uid);
                    }),
              ),
              title: Text(user.name),
              trailing: IconButton(
                tooltip: '名前、アイコンを再読み込み',
                icon: const Icon(Icons.sync),
                onPressed: () {
                  PageService()
                      .showConfirmDialog('Discordで再認証して、名前、アイコンを再読み込みする', () {
                    LoginService().login();
                    PageService().back();
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            UserPageBasic(user: user),
            const Spacer(),
            Button(
              color: Theme.of(context).colorScheme.error,
              onTap: () {
                PageService().showConfirmDialog('ログアウトする', () {
                  LoginService().logout(ref);
                  PageService().back();
                });
              },
              text: 'ログアウト',
            ),
            const SizedBox(height: 16),
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
