import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/plan_entity.dart';
import '../../entity/user_entity.dart';
import '../../provider/create_plan_provider.dart';
import '../../provider/plan_list_provider.dart';

class CreatePlanDialog extends ConsumerWidget {
  const CreatePlanDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createPlan = ref.watch(createPlanProvider);

    // final TextEditingController titleController = TextEditingController();
    // titleController.text = createPlan.title;

    return AlertDialog(
        title: const Text('予定を作る'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            titleField(createPlan.titleController),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('キャンセル'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('作成'),
            onPressed: () {
              DateTime start = DateTime.now().add(const Duration(days: 1));
              UserEntity owner = const UserEntity('user01', '太郎');
              PlanEntity newPlan = PlanEntity('aaa', owner,
                  createPlan.titleController.text, 'desc', start, 5);

              ref.read(planListProvider.notifier).add(newPlan);
              ref.read(createPlanProvider.notifier).reset();

              Navigator.pop(context);
            },
          ),
        ]);
  }

  TextFormField titleField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(hintText: "タイトル"),
      maxLengthEnforcement: MaxLengthEnforcement.none, enabled: true,
      // 入力数
      maxLength: 10,
      style: TextStyle(color: Colors.red),
      maxLines: 1,
    );
  }
}
