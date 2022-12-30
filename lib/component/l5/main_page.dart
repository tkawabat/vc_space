import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vc_space/component/l2/tag_field.dart';

import '../../service/const_service.dart';
import '../../service/twitter_service.dart';
import '../../entity/user_entity.dart';
import '../../provider/login_provider.dart';
import '../l3/header.dart';
import '../l3/room_list.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginUserStream = ref.watch(loginUserStreamProvider);
    final uid = loginUserStream.when(
      data: (UserEntity? users) => users?.id ?? 'no login',
      error: (error, stack) => Text('Error: $error'),
      loading: () => 'loading...',
    );

    return Scaffold(
      appBar: Header(title: dotenv.get('TITLE')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("uid=$uid"),
            ElevatedButton(
              onPressed: () => twitterLogin(),
              child: const Text("ログイン"),
            ),
            TagField(samples: ConstService.sampleRoomTags),
            const RoomList(),
          ],
        ),
      ),
    );
  }
}
