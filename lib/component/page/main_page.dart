import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:vc_space/entity/wait_time_entity.dart';

import '../../model/room_model.dart';
import '../../model/wait_time_model.dart';
import '../../provider/room_list_provider.dart';
import '../../service/const_system.dart';
import '../../service/page_service.dart';
import '../../service/login_service.dart';
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
              // LoginService().logout();
              // RoomModel().hoge();

              final waitTimeEntity = WaitTimeEntity(
                  uid: '5fdcbb10-31fd-4e9a-9db6-a2541a96d43b',
                  waitTimeId: ConstSystem.waitTimeBeforeInsertId,
                  startTime: DateTime.now(),
                  endTime: DateTime.now(),
                  updatedAt: DateTime.now());
              WaitTimeModel().insert(waitTimeEntity);
            },
            child: const Text("デバッグ"),
          ),
          ElevatedButton(
            onPressed: () async {
              // LoginService().logout();
              var list = await WaitTimeModel().getList();
              debugPrint(list.toString());
              // ref.read(roomListProvider.notifier).getList();
              // PageService().snackbar('部屋を取得しました', SnackBarType.info);
            },
            child: const Text("デバッグ"),
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
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
