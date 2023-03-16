// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../entity/room_chat_entity.dart';
import '../../entity/user_entity.dart';
import '../../model/room_chat_model.dart';
import '../../provider/enter_room_chat_provider.dart';
import '../../provider/login_user_provider.dart';
import '../../service/analytics_service.dart';
import '../l1/loading.dart';

class VCChat extends HookConsumerWidget {
  final int roomId;

  const VCChat({super.key, required this.roomId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<RoomChatEntity> roomChatList = ref.watch(enterRoomChatProvider);
    final UserEntity? user = ref.watch(loginUserProvider);

    if (user == null) {
      return const Loading();
    }

    final List<types.Message> messages = roomChatList
        .map((chat) => types.TextMessage(
              author: types.User(
                id: chat.uid,
                firstName: chat.name,
                imageUrl: chat.photo,
              ),
              createdAt: chat.updatedAt.millisecondsSinceEpoch,
              text: chat.text,
              id: chat.roomChatId.toString(),
            ))
        .toList();

    return Chat(
      user:
          types.User(id: user.uid, imageUrl: user.photo, firstName: user.name),
      messages: messages,
      onSendPressed: (_) {},
      customBottomWidget: textInput(user),
      showUserAvatars: true,
      showUserNames: true,
      l10n: const _ChatL10nJa(),
    );
  }

  Widget textInput(UserEntity user) {
    final TextEditingController controller = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.text,
            maxLines: null,
            autofocus: true,
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'メッセージを入力してください',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: EdgeInsets.all(8),
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            final text = controller.text;
            controller.text = '';
            RoomChatModel().insert(roomId, user, text).then((_) {
              logEvent(LogEventName.room_chat, 'member');
            });
          },
          icon: const Icon(Icons.send),
        ),
      ],
    );
  }
}

class _ChatL10nJa extends ChatL10n {
  const _ChatL10nJa(
      {super.attachmentButtonAccessibilityLabel = '画像アップロード',
      super.emptyChatPlaceholder = 'メッセージがありません',
      super.fileButtonAccessibilityLabel = 'ファイル',
      super.inputPlaceholder = 'メッセージを入力してください',
      super.sendButtonAccessibilityLabel = '送信',
      super.unreadMessagesLabel = '未読'})
      : super();
}
