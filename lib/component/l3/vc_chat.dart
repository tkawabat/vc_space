// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../entity/room_entity.dart';
import '../../entity/user_entity.dart';
import '../../model/room_model.dart';

class VCChat extends HookConsumerWidget {
  final UserEntity user;
  final RoomEntity room;

  const VCChat({super.key, required this.user, required this.room});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<types.Message> messages = room.chats
        .map((chat) => types.TextMessage(
              author: types.User(
                  id: chat.userId, firstName: chat.name, imageUrl: chat.photo),
              createdAt: chat.updatedAt.millisecondsSinceEpoch,
              text: chat.text,
              id: chat.userId + chat.updatedAt.toString(),
            ))
        .toList();

    return Chat(
      user: types.User(id: user.id, imageUrl: user.photo, firstName: user.name),
      messages: messages,
      onSendPressed: (types.PartialText text) {
        RoomModel().addChat(room, user, text.text);
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
