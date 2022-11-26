import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/plan_entity.dart';
import '../../entity/user_entity.dart';
import '../../provider/plan_list_provider.dart';
import '../l3/plan_list.dart';

class PlanDetailPage extends HookConsumerWidget {
  const PlanDetailPage({Key? key, required this.plan}) : super(key: key);

  final PlanEntity plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plan.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("戻る"),
            ),
          ],
        ),
      ),
    );
  }
}
