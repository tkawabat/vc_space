import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../service/twitter_service.dart';
import '../../entity/user_entity.dart';
import '../../provider/login_provider.dart';
import '../l3/header.dart';
import '../l3/plan_list.dart';
import '../l4/create_plan_dialog.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);

  final String title;

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
      appBar: Header(
        title: dotenv.get('TITLE'),
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
