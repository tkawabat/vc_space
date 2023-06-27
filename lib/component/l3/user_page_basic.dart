import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:vc_space/service/user_service.dart';

import '../../entity/user_entity.dart';
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
      PageService().snackbar('入力値に問題があります', SnackBarType.error);
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
        followerNumber: user.followerNumber,
        updatedAt: DateTime.now());

    UserService().update(newUser);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilder(
      key: formKey,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              greetingField(user.greeting),
              const SizedBox(height: 16),
              TagField(
                key: tagKey,
                samples: ConstService.sampleTagsUser,
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
