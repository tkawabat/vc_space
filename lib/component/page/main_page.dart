import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../provider/room_list_provider.dart';
import '../../service/page_service.dart';
import '../dialog/room_create_dialog.dart';
import '../l3/header.dart';
import '../l3/room_list.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    return Scaffold(
      appBar: Header(title: dotenv.get('TITLE')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
      floatingActionButton: FloatingActionButton(
        tooltip: '部屋を作る',
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) {
                return RoomCreateDialog();
              });
        },
        child: const Icon(Icons.add, size: 48),
      ),
    );
  }
}
