import 'package:flutter/material.dart';

import '../l4/create_plan_dialog.dart';

class CreatePlanButton extends StatelessWidget {
  const CreatePlanButton({super.key});

  Future<void> showCreatePlanDialog(context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return const CreatePlanDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: '部屋を作る',
      child: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            showCreatePlanDialog(context);
          }),
    );
  }
}
