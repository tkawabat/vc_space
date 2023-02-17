import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../../provider/login_provider.dart';
import '../../service/page_service.dart';
import '../../service/const_service.dart';
import '../../service/time_service.dart';
import '../../service/wait_time_service.dart';

class WaitTimeInput extends HookConsumerWidget {
  final String uid;

  WaitTimeInput(this.uid, {super.key});

  final formKey = GlobalKey<FormBuilderState>();

  void addWaitTime() {
    if (!(formKey.currentState?.saveAndValidate() ?? false)) {
      PageService().snackbar('入力値に問題があります', SnackBarType.error);
      return;
    }
    final fields = formKey.currentState!.value;

    DateTime start = fields['startTime'];
    DateTime end = fields['endTime'];
    if (!start.isBefore(end)) {
      PageService().snackbar('終了時間は開始時間より後にしてください。', SnackBarType.error);
      return;
    }
    if (end.difference(start).inHours > 8) {
      PageService().snackbar('空き時間は最長8時間です。', SnackBarType.error);
      return;
    }

    WaitTimeService().add(uid, fields['startTime'], fields['endTime']);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loginUserProvider);

    if (user == null || user.uid != uid) return const SizedBox();

    final startTime = TimeService().getStepNow(ConstService.stepTime);
    final endTime = startTime.add(const Duration(hours: 1));

    return FormBuilder(
        key: formKey,
        child: Row(children: [
          const Text('空き\n登録', style: TextStyle(fontWeight: FontWeight.bold)),
          timeField('startTime', '開始', startTime),
          timeField('endTime', '終了', endTime),
          IconButton(
              tooltip: '登録する',
              icon: const Icon(Icons.check),
              onPressed: () => addWaitTime()),
        ]));
  }

  Widget timeField(String name, String label, DateTime initialValue) {
    final formatter = DateFormat('MM/dd(E) HH:mm', 'ja');
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
        firstDate: DateTime.now(),
        lastDate:
            DateTime.now().add(const Duration(days: ConstService.calendarMax)),
        showCursor: true,
        controller: controller,
      ),
    );
  }
}
