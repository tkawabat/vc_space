import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../../entity/wait_time_entity.dart';
import '../../provider/login_provider.dart';
import '../../service/page_service.dart';
import '../../service/const_service.dart';
import '../../service/time_service.dart';
import '../../service/wait_time_service.dart';

class WaitTimeRow extends HookConsumerWidget {
  final String uid;
  final WaitTimeEntity? waitTime;

  WaitTimeRow(
    this.uid, {
    super.key,
    this.waitTime,
  });

  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loginUserProvider);

    bool canUpdate = user != null && user.uid == uid;

    final startTime =
        waitTime?.startTime ?? TimeService().getStepNow(ConstService.stepTime);
    final endTime =
        waitTime?.endTime ?? startTime.add(const Duration(hours: 1));

    return FormBuilder(
        key: formKey,
        child: Row(children: [
          const Text('空き時間', style: TextStyle(fontWeight: FontWeight.bold)),
          timeField('startTime', '開始', startTime),
          timeField('endTime', '終了', endTime),
          if (canUpdate && waitTime == null)
            IconButton(
                tooltip: '保存する',
                icon: const Icon(Icons.check),
                onPressed: () {
                  PageService().showConfirmDialog('空き時間を登録しますか？', () {
                    if (!(formKey.currentState?.saveAndValidate() ?? false)) {
                      PageService().snackbar('入力値に問題があります', SnackBarType.error);
                      return;
                    }
                    // TODO 開始のほうがあとにならないように
                    final fields = formKey.currentState!.value;
                    WaitTimeService()
                        .add(user.uid, fields['startTime'], fields['endTime']);
                  });
                }),
          if (canUpdate && waitTime != null)
            IconButton(
              tooltip: '削除する',
              icon: const Icon(Icons.delete),
              onPressed: () => PageService().showConfirmDialog(
                  '空き時間を削除しますか？',
                  () =>
                      WaitTimeService().delete(user.uid, waitTime!.waitTimeId)),
            ),
        ]));
  }

  Widget timeField(String name, String label, DateTime initialValue) {
    final formatter = DateFormat('HH:mm', 'ja');
    final controller = TextEditingController();
    final focusNode = FocusNode();

    return Flexible(
      child: FormBuilderDateTimePicker(
        name: name,
        focusNode: focusNode,
        autovalidateMode: AutovalidateMode.always,
        initialValue: initialValue,
        decoration: InputDecoration(labelText: label),
        format: formatter,
        showCursor: true,
        controller: controller,
        inputType: InputType.time,
        onChanged: (value) {
          final DateTime time = value ?? DateTime.now();
          final newValue =
              TimeService().getStepDateTime(time, ConstService.stepTime);

          if (time == newValue) return;

          formKey.currentState?.fields['startTime']?.didChange(newValue);
          formKey.currentState?.fields['startTime']
              ?.invalidate('${ConstService.stepTime}分区切りに変更しました');
          focusNode.unfocus();

          Timer(const Duration(microseconds: 1), () {
            controller.text = formatter.format(newValue);
          });
        },
      ),
    );
  }
}
