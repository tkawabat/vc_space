import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../entity/user_search_input_entity.dart';
import '../../provider/user_search_provider.dart';
import '../../service/analytics_service.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../l1/cancel_button.dart';
import '../l2/tag_field.dart';

class UserSearchDialog extends HookConsumerWidget {
  UserSearchDialog({super.key});

  final formKey = GlobalKey<FormBuilderState>();
  final tagKey = GlobalKey<TagFieldState>();

  void submit(
      BuildContext context, WidgetRef ref, UserSearchInputEntity searchUser) {
    Navigator.pop(context);

    if (!(formKey.currentState?.saveAndValidate() ?? false)) {
      PageService().snackbar('入力値に問題があります', SnackBarType.error);
      return;
    }
    final fields = formKey.currentState!.value;
    final tags = tagKey.currentState!.tagsController.getTags ?? [];

    final newUserSearch = searchUser.copyWith(
      time: fields['time'],
      tags: tags,
    );

    logEvent(LogEventName.user_search_modify, 'member');

    ref.read(userSearchProvider.notifier).set(newUserSearch);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchUser = ref.watch(userSearchProvider);

    List<Widget> list = [
      timeField(searchUser.time),
      TagField(
        key: tagKey,
        samples: ConstService.sampleTagsPlay,
        maxTagNumber: ConstService.maxTagLength,
        initialTags: searchUser.tags,
      ),
    ];

    return FormBuilder(
        key: formKey,
        child: AlertDialog(
            title: const Text('条件変更'),
            content: SizedBox(
                width: 400,
                height: 200,
                child: ListView.separated(
                  itemCount: list.length,
                  itemBuilder: (context, i) => list[i],
                  separatorBuilder: (context, i) => const SizedBox(height: 16),
                )),
            actions: [
              const CancelButton(),
              TextButton(
                  child: const Text('検索'),
                  onPressed: () => submit(context, ref, searchUser)),
            ]));
  }

  FormBuilderField timeField(DateTime initialValue) {
    final formatter = DateFormat('MM/dd(E) HH:mm', 'ja');
    final controller = TextEditingController();
    final focusNode = FocusNode();

    return FormBuilderDateTimePicker(
      name: 'time',
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.always,
      initialValue: initialValue,
      decoration: const InputDecoration(labelText: '誘って！　の時間'),
      format: formatter,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      showCursor: true,
      controller: controller,
    );
  }
}
