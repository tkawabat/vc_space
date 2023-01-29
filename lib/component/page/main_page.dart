import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../provider/room_list_provider.dart';
import '../../service/page_service.dart';
import '../l3/header.dart';
import '../l3/room_list.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    return Scaffold(
      appBar: Header(title: dotenv.get('TITLE')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                ref.read(roomListProvider.notifier).getList();
                PageService().snackbar('部屋を取得しました', SnackBarType.info);
              },
              child: const Text("更新"),
            ),
            const RoomList(),
          ],
        ),
      ),
    );
  }
}
