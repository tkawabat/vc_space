import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../entity/user_entity.dart';
import '../../model/user_model.dart';
import '../../provider/login_provider.dart';
import '../../provider/user_list_provider.dart';
import '../../service/const_service.dart';

import '../../service/page_service.dart';
import '../l1/button.dart';
import '../l2/tag_field.dart';

class UserPageBasic extends HookConsumerWidget {
  final UserEntity user;

  UserPageBasic({Key? key, required this.user}) : super(key: key);

  final formKey = GlobalKey<FormBuilderState>();
  final tagKey = GlobalKey<TagFieldState>();

  Future<void> submit(WidgetRef ref) async {
    if (!(formKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }
    var fields = formKey.currentState!.value;
    var tags = tagKey.currentState!.tagsController.getTags ?? [];

    UserEntity newUser = UserEntity(
        uid: user.uid,
        name: user.name,
        photo: user.photo,
        discordName: user.discordName,
        greeting: fields['greeting'],
        tags: tags,
        follows: user.follows,
        updatedAt: DateTime.now());

    UserModel().updateUser(newUser).then((_) {
      ref.read(loginUserProvider.notifier).set(newUser);
      ref.read(userListProvider.notifier).set(newUser);
      PageService().snackbar('保存しました。', AnimatedSnackBarType.info);
    }).catchError((_) {
      PageService().snackbar('保存に失敗しました。', AnimatedSnackBarType.error);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilder(
      key: formKey,
      child: Container(
          height: 400,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('基本情報', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              greetingField(user.greeting),
              const SizedBox(height: 16),
              TagField(
                key: tagKey,
                samples: ConstService.sampleUserTags,
                initialTags: user.tags,
                maxTagNumber: ConstService.maxTagLength,
              ),
              const SizedBox(height: 24),
              Button(
                alignment: Alignment.centerRight,
                onTap: () => submit(ref),
                text: '保存',
              ),
            ],
          )),
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
