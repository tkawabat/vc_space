import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../../entity/room_entity.dart';
import '../../provider/create_room_provider.dart';
import '../../provider/room_list_provider.dart';
import '../../service/const_service.dart';

class CreateRoomDialog extends ConsumerWidget {
  CreateRoomDialog({super.key});

  final formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    const space = SizedBox(height: 12);

    return FormBuilder(
        key: formKey,
        child: AlertDialog(
            title: const Text('部屋を作る'),
            content: SizedBox(
                width: double.maxFinite,
                child: Scrollbar(
                    controller: scrollController,
                    child: ListView(
                      controller: scrollController,
                      children: <Widget>[
                        titleField(),
                        space,
                        descriptionField(),
                        space,
                        startTimeField(),
                        space,
                        maxNumberField(),
                        space,
                        space,
                        enterTypeField(),
                        space,
                        tagField(),
                      ],
                    ))),
            actions: <Widget>[
              TextButton(
                child: const Text('キャンセル'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('作成'),
                onPressed: () {
                  if (!(formKey.currentState?.saveAndValidate() ?? false)) {
                    return;
                  }
                  var fields = formKey.currentState!.value;

                  RoomEntity newRoom = createSampleRoom(fields["title"]);

                  ref.read(roomListProvider.notifier).add(newRoom);
                  ref.read(createRoomProvider.notifier).reset();

                  Navigator.pop(context);
                },
              ),
            ]));
  }

  FormBuilderField titleField() {
    const labelText = 'タイトル (最大${ConstService.roomTitleMax}文字)';

    return FormBuilderTextField(
      name: 'title',
      autovalidateMode: AutovalidateMode.always,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.maxLength(ConstService.roomTitleMax),
      ]),
      decoration: const InputDecoration(labelText: labelText),
    );
  }

  FormBuilderField descriptionField() {
    const labelText = '説明 (最大${ConstService.roomDescriptionMax}文字)';

    return FormBuilderTextField(
      name: 'description',
      autovalidateMode: AutovalidateMode.always,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.maxLength(ConstService.roomDescriptionMax),
      ]),
      decoration: const InputDecoration(labelText: labelText),
    );
  }

  FormBuilderField startTimeField() {
    return FormBuilderDateTimePicker(
      name: 'startTime',
      autovalidateMode: AutovalidateMode.always,
      initialValue: DateTime.now(),
      decoration: const InputDecoration(labelText: '開始時間'),
      format: DateFormat('MM/dd(E) HH:mm', 'ja'),
    );
  }

  FormBuilderField maxNumberField() {
    const labelText = '最大人数 (最大${ConstService.roomMaxNumber}人)';

    return FormBuilderSlider(
      name: 'maxNumber',
      autovalidateMode: AutovalidateMode.always,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.max(ConstService.roomMaxNumber),
      ]),
      decoration: const InputDecoration(labelText: labelText),
      initialValue: 4,
      min: 2,
      max: ConstService.roomMaxNumber.toDouble(),
      divisions: ConstService.roomMaxNumber - 2,
      maxTextStyle: const TextStyle(fontSize: 12),
      minTextStyle: const TextStyle(fontSize: 12),
    );
  }

  FormBuilderField enterTypeField() {
    List<String> items = ['制限なし', 'フォローのみ', 'パスワード'];

    return FormBuilderDropdown<String>(
      name: 'enterType',
      autovalidateMode: AutovalidateMode.always,
      initialValue: items[0],
      decoration: const InputDecoration(labelText: '入室制限'),
      items: items
          .map((value) => DropdownMenuItem(
                alignment: AlignmentDirectional.centerStart,
                value: value,
                child: Text(value),
              ))
          .toList(),
    );
  }

  FormBuilderField tagField() {
    // TODO

    return FormBuilderChoiceChip<String>(
      name: 'tag',
      autovalidateMode: AutovalidateMode.always,
      // initialValue: ,
      decoration: const InputDecoration(labelText: 'タグ'),
      options: const [
        FormBuilderChipOption<String>(value: 'a'),
        FormBuilderChipOption<String>(value: 'b'),
      ],
    );
  }
}
