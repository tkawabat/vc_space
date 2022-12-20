import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../service/twitter_service.dart';
import '../../entity/plan_entity.dart';
import '../../entity/user_entity.dart';
import '../../provider/login_provider.dart';
import '../l3/plan_list.dart';
import '../l4/create_plan_dialog.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  PlanEntity createPlan() {
    DateTime start = DateTime.now().add(const Duration(days: 1));
    UserEntity owner = createSampleUser();
    return PlanEntity('id_test', owner, 'title_test', 'desc_test', start, 4);
  }

  Future<void> showCreatePlanDialog(context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return const CreatePlanDialog();
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginUserStream = ref.watch(loginUserStreamProvider);
    final uid = loginUserStream.when(
      data: (UserEntity? users) => users?.id ?? 'no login',
      error: (error, stack) => Text('Error: $error'),
      loading: () => 'loading...',
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(dotenv.get('TITLE')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("uid=$uid"),
            ElevatedButton(
              onPressed: () {
                twitterLogin();
              },
              child: const Text("ログイン"),
            ),
            ElevatedButton(
              onPressed: () {
                showCreatePlanDialog(context);
              },
              child: const Text("タップ"),
            ),
            const PlanList(),
          ],
        ),
      ),
    );
  }
}
