import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/room_entity.dart';
import '../model/room_model.dart';
import '../model/room_user_model.dart';
import '../route.dart';
import '../service/error_service.dart';
import '../service/page_service.dart';
// import 'user_search_provider.dart';

final enterRoomProvider = StateNotifierProvider<EnterRoomNotifer, RoomEntity?>(
    (ref) => EnterRoomNotifer());

class EnterRoomNotifer extends StateNotifier<RoomEntity?> {
  EnterRoomNotifer() : super(null);

  Map<String, StreamSubscription?> subscriptions = {
    'room': null,
    'room_user': null,
  };

  Future<void> startUpdate(int roomId) async {
    stopUpdate();

    onData(_) async {
      RoomModel().getById(roomId).then((room) {
        state = room;

        // 人増えるまでコメントアウト
        // if (room != null && room.tags.isNotEmpty) {
        //   PageService()
        //       .ref
        //       ?.read(userSearchProvider.notifier)
        //       .setTags([room.tags[0]]);
        // }
      }).catchError((_) {
        PageService().transition(PageNames.home);
        PageService().snackbar('部屋情報の取得でエラーが発生しました', SnackBarType.error);
        return null;
      });
    }

    subscriptions['room'] = RoomModel().getStream(roomId).listen(onData,
        onError: ErrorService().onError(null, '', onError: () => stopUpdate()));

    subscriptions['room_user'] = RoomUserModel().getStream(roomId).listen(
        onData,
        onError: ErrorService().onError(null, '', onError: () => stopUpdate()));
  }

  Future<void> stopUpdate() {
    List<Future> futureList = [];
    subscriptions.forEach((key, subscription) {
      if (subscription == null) return;
      futureList.add(subscription.cancel());
      subscriptions[key] = null;
    });

    return Future.wait(futureList).then((_) => state = null);
  }

  @override
  void dispose() async {
    await stopUpdate();
    super.dispose();
  }
}
