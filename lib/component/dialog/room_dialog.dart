import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../entity/room_entity.dart';
import '../../entity/user_entity.dart';
import '../../entity/user_private_entity.dart';
import '../../provider/login_user_private_provider.dart';
import '../../provider/login_user_provider.dart';
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
    final UserPrivateEntity? loginUserPrivate =
        ref.watch(loginUserPrivateProvider);

    DateFormat formatter = DateFormat('M/d(E) HH:mm', "ja_JP");
    final String start = '${formatter.format(room.startTime)}〜';

    final description = room.description.isNotEmpty
        ? Text(room.description)
        : const Text('部屋説明無し', style: TextStyle(color: Colors.black54));

    final bool passwordEnabled = room.enterType == EnterType.password &&
        !RoomService().isJoined(room, loginUser?.uid ?? userNotFound.uid);

    String? joinErrorMessage =
        RoomService().getJoinErrorMessage(room, loginUser, loginUserPrivate);
    String submitButtonText = '参加する';
    TextStyle submitButtonTextStyle = const TextStyle();
    void Function()? submitButtonOnPress;
    if (RoomService().isCompletelyJoined(room, loginUser)) {
      submitButtonText = '入室する';
      submitButtonOnPress = () {
        Navigator.pop(context);
        RoomService().enter(room.roomId);
      };
    } else if (RoomService().isOffered(room, loginUser)) {
      submitButtonText = 'お誘いを受ける';
      submitButtonOnPress = () {
        Navigator.pop(context);
        RoomService().offerOk(RoomService().getRoomUser(room, loginUser!.uid)!);
      };
    } else if (joinErrorMessage == null) {
      // 普通の入室
      submitButtonOnPress = () => joinRoom(context, loginUser!);
    } else {
      // 入室できない
      submitButtonOnPress =
          () => PageService().snackbar(joinErrorMessage, SnackBarType.error);
      submitButtonTextStyle =
          const TextStyle(decoration: TextDecoration.lineThrough);
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
                RoomTagList(room),
                const Spacer(),
                passwordField(passwordEnabled),
              ],
            )),
        actions: [
          const CancelButton(),
          TextButton(
            onPressed: submitButtonOnPress,
            child: Text(submitButtonText, style: submitButtonTextStyle),
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
