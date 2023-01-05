import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConfirmDialog extends HookConsumerWidget {
  final String text;
  final String submitText;
  final Function() onSubmit;
  final Function()? onCancel;

  const ConfirmDialog({
    super.key,
    required this.text,
    required this.onSubmit,
    this.submitText = '決定',
    this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
        // title: const Text('部屋を作る'),
        content: Text(text),
        actions: [
          TextButton(
              child: const Text('キャンセル'),
              onPressed: () {
                if (onCancel != null) onCancel!();
                Navigator.pop(context);
              }),
          TextButton(
              child: Text(submitText),
              onPressed: () {
                onSubmit();
                Navigator.pop(context);
              }),
        ]);
  }
}
