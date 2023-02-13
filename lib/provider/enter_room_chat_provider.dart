import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/room_chat_entity.dart';
import '../model/room_chat_model.dart';
import '../service/error_service.dart';

final enterRoomChatProvider =
    StateNotifierProvider<EnterRoomChatNotifer, List<RoomChatEntity>>(
        (ref) => EnterRoomChatNotifer());

class EnterRoomChatNotifer extends StateNotifier<List<RoomChatEntity>> {
  EnterRoomChatNotifer() : super([]);

  StreamSubscription? subscription;

  Future<void> startUpdate(int roomId) async {
    await stopUpdate();

    onData(List<Map<String, dynamic>> list) {
      debugPrint('room_chat onData');
      state = list.map((e) => RoomChatEntity.fromJson(e)).toList();
    }

    subscription = RoomChatModel().getStream(roomId).listen(onData,
        onError: ErrorService().onError(null, '', onError: () => stopUpdate()));
  }

  Future<void> stopUpdate() {
    debugPrint('stop room chat update');

    List<Future> futureList = [];
    if (subscription != null) {
      futureList.add(subscription!.cancel());
      subscription = null;
    }
    return Future.wait(futureList).then((_) => state = []);
  }

  @override
  void dispose() async {
    await stopUpdate();
    super.dispose();
  }
}
