import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../entity/wait_time_entity.dart';
import '../../provider/login_provider.dart';
import '../../service/page_service.dart';
import '../../service/const_service.dart';
import '../../service/time_service.dart';
import '../../service/wait_time_service.dart';

class WaitTimeRow extends ConsumerWidget {
  final WaitTimeEntity? waitTime;

  WaitTimeRow({super.key, this.waitTime});

  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loginUserProvider);

    final startTime =
        waitTime?.startTime ?? TimeService().getStepNow(ConstService.stepTime);
    final endTime =
        waitTime?.endTime ?? startTime.add(const Duration(hours: 1));

    final fields = formKey.currentState?.fields;
    final canUpdate = user != null &&
        waitTime?.startTime.compareTo(fields?['startTime'] as DateTime) == 0 &&
        waitTime?.endTime.compareTo(fields?['endTime'] as DateTime) == 0;

    return FormBuilder(
        key: formKey,
        child: Row(children: [
          const Text('空き時間', style: TextStyle(fontWeight: FontWeight.bold)),
          timeField('startTime', '開始', startTime),
          timeField('endTime', '終了', endTime),
          if (canUpdate)
            IconButton(
                tooltip: '元に戻す',
                icon: const Icon(Icons.undo),
                onPressed: () =>
                    PageService().showConfirmDialog('変更を元に戻します。', () {
                      fields!['startTime']?.didChange(waitTime!.startTime);
                      fields['endTime']?.didChange(waitTime!.endTime);
                    })),
          if (canUpdate || waitTime == null)
            IconButton(
                tooltip: '保存する',
                icon: const Icon(Icons.check),
                onPressed: () {
                  PageService().showConfirmDialog('空き時間を登録しますか？', () {
                    if (!(formKey.currentState?.saveAndValidate() ?? false)) {
                      PageService().snackbar('入力値に問題があります', SnackBarType.error);
                      return;
                    }
                    final fields = formKey.currentState!.value;
                    WaitTimeService()
                        .add(user!.uid, fields['startTime'], fields['endTime']);
                  });
                }),
          if (!canUpdate && waitTime != null)
            IconButton(
              tooltip: '削除する',
              icon: const Icon(Icons.delete),
              onPressed: user == null
                  ? null
                  : () => PageService().showConfirmDialog(
                      '空き時間を削除しますか？',
                      () => WaitTimeService()
                          .delete(user.uid, waitTime!.waitTimeId)),
            ),
        ]));
  }

  Widget timeField(String name, String label, DateTime initialValue) {
    final formatter = DateFormat('HH:mm', 'ja');
    final controller = TextEditingController();
    final focusNode = FocusNode();

    // TODO 日付またぎ問題

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
