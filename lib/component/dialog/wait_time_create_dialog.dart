import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../entity/user_entity.dart';
import '../../provider/login_user_provider.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../../service/time_service.dart';
import '../../service/wait_time_service.dart';
import '../l1/cancel_button.dart';

class WaitTimeCreateDialog extends HookConsumerWidget {
  WaitTimeCreateDialog({super.key});

  final formKey = GlobalKey<FormBuilderState>();

  void submit(BuildContext context, WidgetRef ref) async {
    Navigator.pop(context);

    final UserEntity? loginUser = ref.read(loginUserProvider);
    if (loginUser == null) {
      PageService().snackbar('空き時間を登録するにはログインが必要です', SnackBarType.error);
      return;
    }

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

    WaitTimeService().add(loginUser, fields['startTime'], fields['endTime']);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startTime = TimeService().getStepNow(ConstService.stepTime);
    final endTime = startTime.add(const Duration(hours: 1));

    return FormBuilder(
      key: formKey,
      child: AlertDialog(
          title: const Text('空き時間を登録'),
          content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  timeField('startTime', '開始', startTime),
                  timeField('endTime', '終了', endTime),
                ],
              )),
          actions: [
            const CancelButton(),
            TextButton(
                child: const Text('登録'), onPressed: () => submit(context, ref)),
          ]),
    );
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
