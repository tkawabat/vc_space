import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../model/room_model.dart';
import '../../model/user_model.dart';
import '../../service/page_service.dart';
import '../dialog/room_edit_dialog.dart';
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
              // RoomModel().hoge();

              UserModel()
                  .getListByWaitTime(0, DateTime(2023, 1, 1))
                  .then((value) {
                debugPrint(value.length.toString());
                value.forEach((e) {
                  debugPrint('user: ${e.name}');
                });
              }).catchError((error) {
                debugPrint(error.toString());
              });
            },
            child: const Text("デバッグ"),
          ),
          RoomList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '部屋を作る',
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) {
                return RoomEditDialog();
              });
        },
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
