import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../entity/room_entity.dart';
import '../../entity/user_entity.dart';
import '../../provider/login_provider.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../l1/cancel_button.dart';
import '../l1/room_user_number.dart';
import '../l2/room_tag_list.dart';
import '../l2/room_user_row.dart';

class RoomDialog extends HookConsumerWidget {
  final RoomEntity room;

  RoomDialog({super.key, required this.room});

  final formKey = GlobalKey<FormBuilderState>();

  Future<void> enterRoom(BuildContext context) async {
    Navigator.pop(context);
    RoomService().enter(room.roomId);
  }

  Future<void> joinRoom(BuildContext context, UserEntity user) async {
    Navigator.pop(context);

    if (!(formKey.currentState?.saveAndValidate() ?? false)) {
      PageService().snackbar('入力値に問題があります', SnackBarType.error);
      return;
    }
    final fields = formKey.currentState!.value;
    RoomService().join(room, user, fields['password']);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserEntity? loginUser = ref.watch(loginUserProvider);
    bool isJoined =
        RoomService().isJoined(room, loginUser?.uid ?? userNotFound.uid);

    DateFormat formatter = DateFormat('M/d(E) HH:mm', "ja_JP");
    String start = '${formatter.format(room.startTime)}〜';

    final description = room.description.isNotEmpty
        ? Text(room.description)
        : const Text('部屋説明無し', style: TextStyle(color: Colors.black54));

    bool passwordEnabled = room.enterType == EnterType.password && !isJoined;

    String submitButtonText = '参加する';
    void Function()? submitButtonOnPress;
    if (loginUser == null) {
      submitButtonOnPress = null;
    } else if (isJoined) {
      submitButtonText = '入室する';
      submitButtonOnPress = () => enterRoom(context);
    } else {
      submitButtonOnPress = () => joinRoom(context, loginUser);
    }

    const TextStyle titleStyle = TextStyle(fontWeight: FontWeight.w700);

    return FormBuilder(
      key: formKey,
      child: AlertDialog(
        title: Text(room.title),
        content: SizedBox(
            width: 400,
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('基本情報', style: titleStyle),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(start, textAlign: TextAlign.start),
                    RoomUserNumber(room: room),
                  ],
                ),
                const SizedBox(height: 2),
                Text('入室制限: ${room.enterType.displayName}'),
                const SizedBox(height: 16),
                const Text('参加者', style: titleStyle),
                const SizedBox(height: 8),
                RoomUserRow(room),
                const SizedBox(height: 8),
                const Text('部屋説明', style: titleStyle),
                const SizedBox(height: 8),
                description,
                const SizedBox(height: 16),
                const Text('タグ', style: titleStyle),
                const SizedBox(height: 8),
                RoomTagList(room: room, user: loginUser),
                const Spacer(),
                passwordField(passwordEnabled),
              ],
            )),
        actions: [
          const CancelButton(),
          TextButton(
            onPressed: submitButtonOnPress,
            child: Text(submitButtonText),
          ),
        ],
      ),
    );
  }

  Widget passwordField(bool enabledPassword) {
    const labelText = 'パスワード (最大${ConstService.roomPasswordMax}文字)';

    return Visibility(
      visible: enabledPassword,
      maintainState: true,
      maintainAnimation: true,
      child: FormBuilderTextField(
        name: 'password',
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.maxLength(ConstService.roomPasswordMax),
        ]),
        decoration: const InputDecoration(labelText: labelText),
        enabled: enabledPassword,
        maxLength: ConstService.roomPasswordMax,
      ),
    );
  }
}
