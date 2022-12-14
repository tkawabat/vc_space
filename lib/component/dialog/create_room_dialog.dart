import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../entity/room_entity.dart';
import '../../entity/user_entity.dart';
import '../../model/room_model.dart';
import '../../provider/login_provider.dart';
import '../../service/const_service.dart';
import '../../service/snackbar_service.dart';
import '../l2/tag_field.dart';

class CreateRoomDialog extends HookConsumerWidget {
  CreateRoomDialog({super.key});

  final formKey = GlobalKey<FormBuilderState>();
  final tagKey = GlobalKey<TagFieldState>();

  Future<void> createRoom(BuildContext context, WidgetRef ref) async {
    if (!(formKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }
    var fields = formKey.currentState!.value;
    var tags = tagKey.currentState!.tagsController.getTags ?? [];

    final UserEntity? loginUser = ref.watch(loginUserProvider);
    if (loginUser == null) {
      return;
    }

    RoomEntity newRoom = RoomEntity(
      ownerId: loginUser.id,
      ownerImage: loginUser.photo,
      title: fields['title'],
      place: fields['placeType'],
      description: fields['description'] ?? '',
      maxNumber: fields['maxNumber'],
      startTime: fields['startTime'],
      tags: tags,
      enterType: fields['enterType'],
      // pass:
      users: [loginUser.id],
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context);

    showSnackBar(context, '部屋を作成しました', SnackBarType.info);

    RoomEntity? createdRoom = await RoomModel().createRoom(newRoom);
    // TODO 入室処理
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();

    List<Widget> list = [
      titleField(),
      placeTypeField(),
      startTimeField(),
      maxNumberField(),
      enterTypeField(),
      TagField(
        key: tagKey,
        samples: ConstService.sampleRoomTags,
        maxTagNumber: ConstService.maxTagLength,
      ),
      descriptionField(),
    ];

    return FormBuilder(
        key: formKey,
        child: AlertDialog(
            title: const Text('部屋を作る'),
            content: SizedBox(
                width: 400,
                height: 600,
                child: Scrollbar(
                    controller: scrollController,
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: list.length,
                      itemBuilder: (context, i) => list[i],
                      separatorBuilder: (context, i) =>
                          const SizedBox(height: 16),
                    ))),
            actions: [
              TextButton(
                child: const Text('キャンセル'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                  child: const Text('作成'),
                  onPressed: () => createRoom(context, ref)),
            ]));
  }

  FormBuilderField titleField() {
    const labelText = 'タイトル (最大${ConstService.roomTitleMax}文字)';

    return FormBuilderTextField(
      name: 'title',
      initialValue: '遊び部屋',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: '入力してください'),
        FormBuilderValidators.maxLength(ConstService.roomTitleMax),
      ]),
      decoration: const InputDecoration(labelText: labelText),
    );
  }

  FormBuilderField descriptionField() {
    const labelText = '説明 (最大${ConstService.roomDescriptionMax}文字)';

    return FormBuilderTextField(
      name: 'description',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        // FormBuilderValidators.required(errorText: '入力してください'),
        FormBuilderValidators.maxLength(ConstService.roomDescriptionMax),
      ]),
      decoration: const InputDecoration(labelText: labelText),
      minLines: 2,
      maxLines: 2,
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
    const labelText = '最大人数';

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
      displayValues: DisplayValues.current,
    );
  }

  FormBuilderField placeTypeField() {
    return FormBuilderDropdown<PlaceType>(
      name: 'placeType',
      autovalidateMode: AutovalidateMode.always,
      initialValue: PlaceType.discord,
      decoration: const InputDecoration(labelText: '遊ぶ場所'),
      items: PlaceType.values
          .map((placeType) => DropdownMenuItem(
                alignment: AlignmentDirectional.centerStart,
                value: placeType,
                child: Text(placeType.displayName),
              ))
          .toList(),
    );
  }

  FormBuilderField enterTypeField() {
    return FormBuilderDropdown<EnterType>(
      name: 'enterType',
      autovalidateMode: AutovalidateMode.always,
      initialValue: EnterType.noLimit,
      decoration: const InputDecoration(labelText: '入室制限'),
      items: EnterType.values
          .map((enterType) => DropdownMenuItem(
                alignment: AlignmentDirectional.centerStart,
                value: enterType,
                child: Text(enterType.displayName),
              ))
          .toList(),
    );
  }
}
