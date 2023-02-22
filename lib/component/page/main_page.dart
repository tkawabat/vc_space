import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../model/room_model.dart';
import '../../model/user_model.dart';
import '../../route.dart';
import '../../service/page_service.dart';
import '../dialog/room_search_dialog.dart';
import '../l1/card_base.dart';
import '../l3/footer.dart';
import '../l3/header.dart';
import '../l3/room_list.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    final information = dotenv.get('INFORMATION', fallback: '');

    return Scaffold(
      appBar: Header(PageNames.home, dotenv.get('TITLE', fallback: '')),
      bottomNavigationBar: const Footer(PageNames.home),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // ElevatedButton(
          //   onPressed: () {
          //     // RoomModel().hoge();

          //     UserModel()
          //         .getListByWaitTime(0, DateTime(2023, 1, 1))
          //         .then((value) {
          //       debugPrint(value.length.toString());
          //       for (var e in value) {
          //         debugPrint('user: ${e.name}');
          //       }
          //     }).catchError((error) {
          //       debugPrint(error.toString());
          //     });
          //   },
          //   child: const Text("デバッグ"),
          // ),
          if (information.isNotEmpty)
            CardBase([
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(information),
              ),
            ]),
          RoomList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: '部屋を絞り込み',
          onPressed: () => showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => RoomSearchDialog()),
          child: const Icon(Icons.search)

          //   tooltip: '部屋を作る',
          //   onPressed: () {
          //     showDialog(
          //         context: context,
          //         barrierDismissible: true,
          //         builder: (_) {
          //           return RoomEditDialog();
          //         });
          //   },
          //   child: const Icon(Icons.add, size: 32),
          ),
    );
  }
}
