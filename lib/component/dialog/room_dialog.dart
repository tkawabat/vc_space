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
import '../../service/const_design.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../../service/url_service.dart';
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

    final urlWidgets = (room.publicUrl != null && room.publicUrl!.isNotEmpty)
        ? [
            const Divider(),
            const Text('リスナー用URL', style: ConstDesign.h3),
            InkWell(
              onTap: () => UrlService().launchUri(room.publicUrl!),
              child: Text(room.publicUrl!, style: ConstDesign.link),
            )
          ]
        : [];

    final bool passwordEnabled = room.enterType == EnterType.password &&
        !RoomService().isJoined(room, loginUser?.uid ?? userNotFound.uid);

    final List<Widget> actions = [
      const CancelButton(),
    ];

    String? joinErrorMessage =
        RoomService().getJoinErrorMessage(room, loginUser, loginUserPrivate);

    if (RoomService().isCompletelyJoined(room, loginUser)) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            RoomService().enter(room.roomId);
          },
          child: const Text('入室する'),
        ),
      );
    } else if (RoomService().isOffered(room, loginUser)) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            RoomService()
                .offerNg(RoomService().getRoomUser(room, loginUser!.uid)!);
          },
          child: const Text('お断りする'),
        ),
      );
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            RoomService()
                .offerOk(RoomService().getRoomUser(room, loginUser!.uid)!);
          },
          child: const Text('参加する'),
        ),
      );
    } else if (joinErrorMessage == null) {
      // 普通の入室
      actions.add(
        TextButton(
          onPressed: () {
            joinRoom(context, loginUser!);
          },
          child: const Text('参加する'),
        ),
      );
    } else {
      // 入室できない
      actions.add(
        TextButton(
          onPressed: () =>
              PageService().snackbar(joinErrorMessage, SnackBarType.error),
          child: const Text('参加する',
              style: TextStyle(decoration: TextDecoration.lineThrough)),
        ),
      );
    }

    return FormBuilder(
      key: formKey,
      child: AlertDialog(
        title: Text(room.title),
        content: SizedBox(
            width: 400,
            height: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                const Divider(),
                const SizedBox(height: 8),
                RoomUserRow(room),
                const SizedBox(height: 8),

                // リスナー用URL
                ...urlWidgets,

                // 部屋説明
                const Divider(),
                const SizedBox(height: 8),
                description,
                const SizedBox(height: 8),

                // タグ
                const Divider(),
                const SizedBox(height: 8),
                RoomTagList(room),
                const Spacer(),
                passwordField(passwordEnabled),
                if (RoomService().isOffered(room, loginUser))
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '主催からのお誘いです！',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade700,
                        ),
                      )),
              ],
            )),
        actions: actions,
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
