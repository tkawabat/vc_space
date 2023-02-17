import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/room_search_provider.dart';
import '../../service/const_service.dart';
import '../l1/cancel_button.dart';
import '../l2/tag_field.dart';

class RoomSearchDialog extends HookConsumerWidget {
  RoomSearchDialog({super.key});

  final formKey = GlobalKey<FormBuilderState>();
  final tagKey = GlobalKey<TagFieldState>();

  void submit(BuildContext context, WidgetRef ref) {
    Navigator.pop(context);

    final tags = tagKey.currentState!.tagsController.getTags ?? [];
    ref.read(roomSearchProvider.notifier).setTags(tags);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchRoom = ref.watch(roomSearchProvider);

    List<Widget> list = [
      // placeTypeField(),
      // startTimeField(),
      // enterTypeField(enabledPassword),
      TagField(
        key: tagKey,
        samples: ConstService.sampleRoomTags,
        maxTagNumber: ConstService.maxTagLength,
        initialTags: searchRoom.tags,
      ),
      // descriptionField(),
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
                  onPressed: () => submit(context, ref)),
            ]));
  }

  // FormBuilderField startTimeField() {
  //   final formatter = DateFormat('MM/dd(E) HH:mm', 'ja');
  //   final controller = TextEditingController();
  //   final focusNode = FocusNode();

  //   return FormBuilderDateTimePicker(
  //     name: 'startTime',
  //     focusNode: focusNode,
  //     autovalidateMode: AutovalidateMode.always,
  //     initialValue: TimeService().getStepNow(ConstService.stepTime),
  //     decoration: const InputDecoration(labelText: '開始時間'),
  //     format: formatter,
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime.now().add(const Duration(days: 60)),
  //     showCursor: true,
  //     controller: controller,
  //     onChanged: (value) {
  //       final DateTime time = value ?? DateTime.now();
  //       final newValue =
  //           TimeService().getStepDateTime(time, ConstService.stepTime);

  //       if (time == newValue) return;

  //       formKey.currentState?.fields['startTime']?.didChange(newValue);
  //       formKey.currentState?.fields['startTime']
  //           ?.invalidate('${ConstService.stepTime}分区切りに変更しました');
  //       focusNode.unfocus();

  //       Timer(const Duration(microseconds: 1), () {
  //         controller.text = formatter.format(newValue);
  //       });
  //     },
  //   );
  // }

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
