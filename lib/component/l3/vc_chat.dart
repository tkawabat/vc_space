// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../entity/user_entity.dart';

class VCChat extends HookConsumerWidget {
  const VCChat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<types.Message> messages = [];
    final user = userNotFound;

    final chatUser = types.User(id: user.id);
    return Chat(
      messages: messages,
      onSendPressed: (types.PartialText text) {},
      user: chatUser,
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
