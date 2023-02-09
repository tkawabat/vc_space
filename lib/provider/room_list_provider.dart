import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/room_model.dart';
import '../entity/room_entity.dart';

final roomListProvider =
    StateNotifierProvider<RoomListNotifer, Map<String, RoomEntity>>(
        (ref) => RoomListNotifer());

class RoomListNotifer extends StateNotifier<Map<String, RoomEntity>> {
  RoomListNotifer() : super({});

  Future<void> get(int roomId) async {
    RoomEntity room = await RoomModel().getById(roomId) ?? roomNotFound;
    add(room);
  }

  Future<void> getList() async {
    // TODO
    final list = await RoomModel().getList(0);
    for (final room in list) {
      add(room);
    }
  }

  void add(RoomEntity room) {
    final newState = {...state};
    // TODO
    newState[room.roomId.toString()] = room;
    state = newState;
  }
}
