import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../entity/room_private_entity.dart';
import '../../model/room_private_model.dart';
import '../../service/analytics_service.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../l1/cancel_button.dart';

class RoomPrivateEditDialog extends HookConsumerWidget {
  final RoomPrivateEntity roomPrivate;

  RoomPrivateEditDialog(this.roomPrivate, {super.key});

  final formKey = GlobalKey<FormBuilderState>();

  Future<void> submit(BuildContext context, WidgetRef ref,
      RoomPrivateEntity roomPrivate) async {
    Navigator.pop(context);

    if (!(formKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }
    var fields = formKey.currentState!.value;

    RoomPrivateEntity newObject = RoomPrivateEntity(
        roomId: roomPrivate.roomId,
        placeUrl: fields['placeUrl'],
        innerDescription: fields['innerDescription'],
        updatedAt: DateTime.now());

    RoomPrivateModel().update(newObject).then((_) {
      logEvent(LogEventName.room_update, 'owner', newObject.roomId.toString());
      PageService().snackbar('保存しました。', SnackBarType.info);
    }).catchError((_) {
      PageService().snackbar('保存に失敗しました。', SnackBarType.error);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilder(
        key: formKey,
        child: AlertDialog(
            title: const Text('参加者向け情報'),
            content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    placeUrlField(roomPrivate.placeUrl),
                    const SizedBox(height: 16),
                    innerDescriptionField(roomPrivate.innerDescription),
                  ],
                )),
            actions: [
              const CancelButton(),
              TextButton(
                  child: const Text('保存'),
                  onPressed: () => submit(context, ref, roomPrivate)),
            ]));
  }

  FormBuilderField placeUrlField(String? initialValue) {
    const labelText = '遊ぶ場所のURL';

    return FormBuilderTextField(
      name: 'placeUrl',
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.url(),
        FormBuilderValidators.maxLength(ConstService.urlMax),
      ]),
      decoration: const InputDecoration(labelText: labelText),
    );
  }

  FormBuilderField innerDescriptionField(String? initialValue) {
    const labelText = '参加者向け説明 (最大${ConstService.roomDescriptionMax}文字)';

    return FormBuilderTextField(
      name: 'innerDescription',
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.maxLength(ConstService.roomDescriptionMax),
      ]),
      decoration: const InputDecoration(labelText: labelText),
      minLines: 2,
      maxLines: 2,
    );
  }
}
