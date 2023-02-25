import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../entity/room_entity.dart';
import '../../model/room_model.dart';
import '../../model/user_model.dart';
import '../../route.dart';
import '../../service/page_service.dart';
import '../dialog/room_dialog.dart';
import '../dialog/room_search_dialog.dart';
import '../dialog/user_dialog.dart';
import '../l1/card_base.dart';
import '../l3/footer.dart';
import '../l3/header.dart';
import '../l3/room_list.dart';

class MainPage extends HookConsumerWidget {
  final int? roomId;
  final String? uid;

  const MainPage({Key? key, this.roomId, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (roomId != null) {
        showRoomDialog(roomId!, context);
      } else if (uid != null) {
        showUserDialog(uid!, context);
      }
    });

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
            CardBase(children: [
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
          child: const Icon(Icons.search)),
    );
  }

  void showRoomDialog(int roomId, BuildContext context) {
    RoomModel().getById(roomId).then((room) {
      if (room == null) {
        PageService().snackbar('部屋が見つかりませんでした', SnackBarType.error);
        return;
      }
      showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) {
            return RoomDialog(
              room: room,
            );
          });
    }).catchError((_) {
      PageService().snackbar('部屋取得エラー', SnackBarType.error);
    });
  }

  void showUserDialog(String uid, BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return UserDialog(
            uid: uid,
          );
        });
  }
}
