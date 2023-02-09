// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../entity/room_chat_entity.dart';
import '../../entity/user_entity.dart';
import '../../model/room_chat_model.dart';
import '../../provider/enter_room_chat_provider.dart';
import '../../provider/login_provider.dart';
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
      onSendPressed: (types.PartialText text) {
        RoomChatModel().insert(roomId, user, text.text);
      },
      showUserAvatars: true,
      showUserNames: true,
      l10n: const _ChatL10nJa(),
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
