import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../entity/room_entity.dart';
import '../../provider/room_search_provider.dart';
import '../../service/analytics_service.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../../service/time_service.dart';
import '../l1/cancel_button.dart';
import '../l2/tag_field.dart';

class RoomSearchDialog extends HookConsumerWidget {
  RoomSearchDialog({super.key});

  final formKey = GlobalKey<FormBuilderState>();
  final tagKey = GlobalKey<TagFieldState>();

  void submit(BuildContext context, WidgetRef ref, RoomEntity searchRoom) {
    Navigator.pop(context);

    if (!(formKey.currentState?.saveAndValidate() ?? false)) {
      PageService().snackbar('入力値に問題があります', SnackBarType.error);
      return;
    }
    final fields = formKey.currentState!.value;
    final tags = tagKey.currentState!.tagsController.getTags ?? [];

    final newRoom = searchRoom.copyWith(
      startTime: fields['startTime'],
      tags: tags,
    );

    logEvent(LogEventName.room_search_modify, 'member');

    ref.read(roomSearchProvider.notifier).set(newRoom);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchRoom = ref.watch(roomSearchProvider);

    List<Widget> list = [
      // placeTypeField(),
      // enterTypeField(enabledPassword),
      startTimeField(searchRoom.startTime),
      TagField(
        key: tagKey,
        samples: ConstService.sampleTagsPlay,
        maxTagNumber: ConstService.maxTagLength,
        initialTags: searchRoom.tags,
      ),
    ];

    return FormBuilder(
        key: formKey,
        child: AlertDialog(
            title: const Text('部屋検索'),
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
                  onPressed: () => submit(context, ref, searchRoom)),
            ]));
  }

  FormBuilderField startTimeField(DateTime initialValue) {
    final formatter = DateFormat('MM/dd(E) HH:mm', 'ja');
    final controller = TextEditingController();
    final focusNode = FocusNode();

    return FormBuilderDateTimePicker(
      name: 'startTime',
      focusNode: focusNode,
      autovalidateMode: AutovalidateMode.always,
      initialValue: initialValue,
      decoration: const InputDecoration(labelText: '開始時間'),
      format: formatter,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      showCursor: true,
      controller: controller,
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
    );
  }

  // FormBuilderField placeTypeField() {
  //   return FormBuilderDropdown<PlaceType>(
  //     name: 'placeType',
  //     autovalidateMode: AutovalidateMode.always,
  //     initialValue: PlaceType.discord,
  //     decoration: const InputDecoration(labelText: '遊ぶ場所'),
  //     items: PlaceType.values
  //         .map((placeType) => DropdownMenuItem(
  //               alignment: AlignmentDirectional.centerStart,
  //               value: placeType,
  //               child: Text(placeType.displayName),
  //             ))
  //         .toList(),
  //   );
  // }

  // FormBuilderField enterTypeField(ValueNotifier<bool> enabledPassword) {
  //   return FormBuilderDropdown<EnterType>(
  //     name: 'enterType',
  //     autovalidateMode: AutovalidateMode.always,
  //     initialValue: EnterType.noLimit,
  //     decoration: const InputDecoration(labelText: '入室制限'),
  //     items: EnterType.values
  //         .map((enterType) => DropdownMenuItem(
  //               alignment: AlignmentDirectional.centerStart,
  //               value: enterType,
  //               child: Text(enterType.displayName),
  //             ))
  //         .toList(),
  //     onChanged: (EnterType? enterType) => enabledPassword.value =
  //         enterType != null && enterType == EnterType.password,
  //   );
  // }
}
