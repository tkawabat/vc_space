import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../entity/user_entity.dart';

class VCChat extends HookConsumerWidget {
  const VCChat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<types.Message> _messages = [];
    final user = createSampleUser();

    final chatUser = types.User(id: user.id);
    return Chat(
      messages: _messages,
      onSendPressed: (types.PartialText text) {},
      user: chatUser,
    );
  }
}
