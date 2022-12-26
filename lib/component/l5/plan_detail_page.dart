import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/plan_entity.dart';
import '../../service/analytics_service.dart';

class PlanDetailPage extends HookConsumerWidget {
  PlanDetailPage({Key? key, required this.plan}) : super(key: key) {
    screenView('plan_detail');
  }

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
