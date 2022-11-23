import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/plan_list_provider.dart';
import '../l3/plan_list.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

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
              onPressed: () => ref.read(planListProvider.notifier).add(),
              child: const Text("タップ"),
            ),
            const PlanList(),
          ],
        ),
      ),
    );
  }
}
