import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/room_entity.dart';
import '../model/room_model.dart';
import '../model/room_user_model.dart';

final enterRoomProvider = StateNotifierProvider<EnterRoomNotifer, RoomEntity?>(
    (ref) => EnterRoomNotifer());

class EnterRoomNotifer extends StateNotifier<RoomEntity?> {
  EnterRoomNotifer() : super(null);

  Map<String, StreamSubscription?> subscriptions = {
    'room': null,
    'room_user': null,
    'room_chat': null,
  };

  Future<void> startUpdate(int roomId) async {
    stopUpdate();

    onData(_) async {
      debugPrint('room onData');
      state = await RoomModel().getById(roomId);
    }

    subscriptions['room'] = RoomModel()
        .getStream(roomId)
        .listen(onData, onError: _onStreamError, cancelOnError: true);

    subscriptions['room_user'] = RoomUserModel()
        .getStream(roomId)
        .listen(onData, onError: _onStreamError, cancelOnError: true);
  }

  Future<void> stopUpdate() {
    debugPrint('stop room update');

    List<Future> futureList = [];
    subscriptions.forEach((key, subscription) {
      if (subscription == null) return;
      futureList.add(subscription.cancel());
      subscriptions[key] = null;
    });

    return Future.wait(futureList).then((_) => state = null);
  }

  void _onStreamError(Object error) {
    // TODO
    debugPrint(error.toString());
    stopUpdate();
  }
}
