import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/room_private_entity.dart';
import '../model/room_private_model.dart';
import '../service/error_service.dart';

final enterRoomPrivateProvider =
    StateNotifierProvider<EnterRoomPrivateNotifer, RoomPrivateEntity?>(
        (ref) => EnterRoomPrivateNotifer());

class EnterRoomPrivateNotifer extends StateNotifier<RoomPrivateEntity?> {
  EnterRoomPrivateNotifer() : super(null);

  StreamSubscription? subscription;

  Future<void> startUpdate(int roomId) async {
    await stopUpdate();

    onData(List<Map<String, dynamic>> list) {
      debugPrint('room_private onData');
      if (list.length != 1) {
        state = null;
        return;
      }
      state = RoomPrivateEntity.fromJson(list[0]);
    }

    subscription = RoomPrivateModel().getStream(roomId).listen(onData,
        onError: ErrorService().onError(null, '', onError: () => stopUpdate()));
  }

  Future<void> stopUpdate() {
    debugPrint('stop room private update');

    List<Future> futureList = [];
    if (subscription != null) {
      futureList.add(subscription!.cancel());
      subscription = null;
    }
    return Future.wait(futureList).then((_) => state = null);
  }

  @override
  void dispose() async {
    await stopUpdate();
    super.dispose();
  }
}
