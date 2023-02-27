import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

import '../../entity/room_user_entity.dart';
import '../../entity/room_entity.dart';
import '../../entity/user_entity.dart';
import '../../model/room_model.dart';
import '../../provider/login_user_provider.dart';
import '../../provider/room_list_join_provider.dart';
import '../../service/const_service.dart';
import '../../service/const_system.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../../service/time_service.dart';
import '../l1/cancel_button.dart';
import '../l2/tag_field.dart';

class RoomEditDialog extends HookConsumerWidget {
  final RoomEntity? room;

  RoomEditDialog({super.key, this.room});

  final formKey = GlobalKey<FormBuilderState>();
  final tagKey = GlobalKey<TagFieldState>();

  Future<void> createRoom(BuildContext context, WidgetRef ref) async {
    Navigator.pop(context);

    if (!(formKey.currentState?.saveAndValidate() ?? false)) {
      PageService().snackbar('入力値に問題があります', SnackBarType.error);
      return;
    }
    final fields = formKey.currentState!.value;
    final tags = tagKey.currentState!.tagsController.getTags ?? [];

    final UserEntity? loginUser = ref.read(loginUserProvider);
    if (loginUser == null) {
      PageService().snackbar('部屋を作るにはログインが必要です', SnackBarType.error);
      return;
    }

    final String? password =
        fields['enterType'] == EnterType.password ? fields['password'] : null;
    final now = DateTime.now();

    RoomEntity newRoom = RoomEntity(
      roomId: ConstSystem.idBeforeInsert,
      owner: loginUser.uid,
      title: fields['title'],
      placeType: fields['placeType'],
      description: fields['description'] ?? '',
      maxNumber: fields['maxNumber'],
      startTime: fields['startTime'],
      tags: tags,
      enterType: fields['enterType'],
      password: password,
      deleted: false,
      updatedAt: now,
      users: [roomUserEmpty],
    );

    await RoomModel().insert(newRoom).then((roomId) {
      PageService().snackbar('部屋を作りました', SnackBarType.info);
      PageService().ref!.read(roomListJoinProvider.notifier).add(newRoom);
      RoomService().enter(roomId);
    }).catchError((_) {
      PageService().snackbar('部屋作成エラー', SnackBarType.error);
    });
  }

  Future<void> updateRoom(BuildContext context, WidgetRef ref) async {
    Navigator.pop(context);

    if (!(formKey.currentState?.saveAndValidate() ?? false)) {
      PageService().snackbar('入力値に問題があります', SnackBarType.error);
      return;
    }
    final fields = formKey.currentState!.value;
    final tags = tagKey.currentState!.tagsController.getTags ?? [];

    if (room == null) {
      PageService().snackbar('部屋修正エラー', SnackBarType.error);
      return;
    }

    final String? password =
        fields['enterType'] == EnterType.password ? fields['password'] : null;
    final now = DateTime.now();

    RoomEntity newRoom = RoomEntity(
      roomId: room!.roomId,
      owner: room!.owner,
      title: fields['title'],
      placeType: fields['placeType'],
      description: fields['description'] ?? '',
      maxNumber: fields['maxNumber'],
      startTime: fields['startTime'],
      tags: tags,
      enterType: fields['enterType'],
      password: password,
      deleted: false,
      updatedAt: now,
      users: room!.users,
    );

    await RoomModel().update(newRoom).then((roomId) {
      PageService().snackbar('部屋を修正しました', SnackBarType.info);
    }).catchError((_) {
      PageService().snackbar('部屋修正エラー', SnackBarType.error);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = ScrollController();
    final ValueNotifier<bool> enabledPassword = useState<bool>(false);

    int roomNumberMin = 2;
    if (room != null && room!.users.length > 2) {
      roomNumberMin = room!.users.length;
    }

    List<Widget> list = [
      titleField(room?.title),
      placeTypeField(room?.placeType),
      startTimeField(room?.startTime),
      maxNumberField(room?.maxNumber, roomNumberMin),
      enterTypeField(room?.enterType, enabledPassword),
      passwordField(enabledPassword),
      TagField(
        key: tagKey,
        initialTags: room?.tags ?? [],
        samples: ConstService.sampleRoomTags,
        maxTagNumber: ConstService.maxTagLength,
      ),
      descriptionField(room?.description),
    ];

    final title = room == null ? '部屋を作る' : '部屋を修正する';

    Widget submitButton = room == null
        ? TextButton(
            child: const Text('作成'), onPressed: () => createRoom(context, ref))
        : TextButton(
            child: const Text('修正'), onPressed: () => updateRoom(context, ref));

    return FormBuilder(
        key: formKey,
        child: AlertDialog(
            title: Text(title),
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
              const CancelButton(),
              submitButton,
            ]));
  }

  FormBuilderField titleField(String? initialValue) {
    const labelText = 'タイトル (最大${ConstService.roomTitleMax}文字)';

    return FormBuilderTextField(
      name: 'title',
      initialValue: initialValue ?? '遊び部屋',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: '入力してください'),
        FormBuilderValidators.maxLength(ConstService.roomTitleMax),
      ]),
      decoration: const InputDecoration(labelText: labelText),
    );
  }

  FormBuilderField descriptionField(String? initialValue) {
    const labelText = '説明 (最大${ConstService.roomDescriptionMax}文字)';

    return FormBuilderTextField(
      name: 'description',
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

  FormBuilderField startTimeField(DateTime? initialValue) {
    final formatter = DateFormat('MM/dd(E) HH:mm', 'ja');
    final controller = TextEditingController();
    final focusNode = FocusNode();

    return FormBuilderDateTimePicker(
      name: 'startTime',
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.always,
      initialValue:
          initialValue ?? TimeService().getStepNow(ConstService.stepTime),
      decoration: const InputDecoration(labelText: '開始時間'),
      format: formatter,
      firstDate: DateTime.now(),
      lastDate:
          DateTime.now().add(const Duration(days: ConstService.calendarMax)),
      showCursor: true,
      controller: controller,
    );
  }

  FormBuilderField maxNumberField(int? initialValue, int minValue) {
    const labelText = '最大人数';

    return FormBuilderSlider(
      name: 'maxNumber',
      autovalidateMode: AutovalidateMode.always,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(),
        FormBuilderValidators.max(ConstService.roomMaxNumber),
      ]),
      decoration: const InputDecoration(labelText: labelText),
      initialValue: initialValue?.toDouble() ?? 4,
      min: minValue.toDouble(),
      max: ConstService.roomMaxNumber.toDouble(),
      divisions: ConstService.roomMaxNumber - (minValue ?? 2),
      displayValues: DisplayValues.current,
    );
  }

  FormBuilderField placeTypeField(PlaceType? initialValue) {
    return FormBuilderDropdown<PlaceType>(
      name: 'placeType',
      autovalidateMode: AutovalidateMode.always,
      initialValue: initialValue ?? PlaceType.discord,
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

  FormBuilderField enterTypeField(
      EnterType? initialValue, ValueNotifier<bool> enabledPassword) {
    return FormBuilderDropdown<EnterType>(
      name: 'enterType',
      autovalidateMode: AutovalidateMode.always,
      initialValue: initialValue ?? EnterType.noLimit,
      decoration: const InputDecoration(labelText: '入室制限'),
      items: EnterType.values
          .map((enterType) => DropdownMenuItem(
                alignment: AlignmentDirectional.centerStart,
                value: enterType,
                child: Text(enterType.displayName),
              ))
          .toList(),
      onChanged: (EnterType? enterType) => enabledPassword.value =
          enterType != null && enterType == EnterType.password,
    );
  }

  Widget passwordField(enabledPassword) {
    // パスワードはエンコードして見れないので、更新時もイチから入れる
    const labelText = 'パスワード (最大${ConstService.roomPasswordMax}文字)';

    return Visibility(
      visible: enabledPassword.value,
      maintainState: true,
      maintainAnimation: true,
      child: FormBuilderTextField(
        name: 'password',
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.maxLength(ConstService.roomPasswordMax),
        ]),
        decoration: const InputDecoration(labelText: labelText),
        enabled: enabledPassword.value,
        maxLength: ConstService.roomPasswordMax,
      ),
    );
  }
}
