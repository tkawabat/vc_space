import 'package:flutter/material.dart';

import '../../service/page_service.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: const Text('キャンセル'),
      onPressed: () => PageService().back(),
    );
  }
}
