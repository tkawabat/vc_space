import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/plan_entity.dart';
import '../../entity/user_entity.dart';
import '../../provider/plan_list_provider.dart';
import '../l3/plan_list.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  PlanEntity createPlan() {
    // DateTime start = DateTime.parse('2022-07-20 20:18:04Z');
    DateTime start = DateTime.now().add(const Duration(days: 1));
    UserEntity owner = const UserEntity('user01', '太郎');
    return PlanEntity('id_test', owner, 'title_test', 'desc_test', start, 4);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () =>
                  ref.read(planListProvider.notifier).add(createPlan()),
              child: const Text("タップ"),
            ),
            const PlanList(),
          ],
        ),
      ),
    );
  }
}
