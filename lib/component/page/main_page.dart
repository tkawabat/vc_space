import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../model/room_model.dart';
import '../../route.dart';
import '../../service/audio_service.dart';
import '../../service/page_service.dart';
import '../dialog/room_dialog.dart';
import '../dialog/room_edit_dialog.dart';
import '../dialog/user_dialog.dart';
import '../l1/card_base.dart';
import '../l3/footer.dart';
import '../l3/header.dart';
import '../l3/past_room_list.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            ElevatedButton(
              onPressed: () {
                // FunctionModel().selectWaitTimeCount(
                //   [],
                //   DateTime(2023, 1, 1),
                //   DateTime(2023, 4, 1, 23, 59),
                // ).then((value) => debugPrint(value.toString()));

                // RoomModel().hoge().then((value) {
                //   debugPrint(value.length.toString());
                //   for (var e in value) {
                //     debugPrint('user: ${e.name}');
                //   }
                // }).catchError((error) {
                //   debugPrint(error.toString());
                // });
                AudioService().play();
              },
              child: const Text("デバッグ1"),
            ),
            if (information.isNotEmpty)
              CardBase(children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(information),
                ),
              ]),
          ])),
          const RoomList(),
          const PastRoomList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: '部屋を作る',
          onPressed: () => showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => RoomEditDialog()),
          child: const Icon(Icons.add)),
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
      PageService().snackbar('部屋は既に削除されています。', SnackBarType.error);
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
