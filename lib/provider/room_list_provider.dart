import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/room_model.dart';
import '../entity/room_entity.dart';

final roomListProvider =
    StateNotifierProvider<RoomListNotifer, Map<String, RoomEntity>>(
        (ref) => RoomListNotifer());

class RoomListNotifer extends StateNotifier<Map<String, RoomEntity>> {
  RoomListNotifer() : super({});

  Future<void> get(String roomId) async {
    RoomEntity room = await RoomModel().getRoom(roomId) ?? roomNotFound;
    add(room);
  }

  Future<void> getList() async {
    final list = await RoomModel().getRoomList();
    for (final room in list) {
      add(room);
    }
  }

  void add(RoomEntity room) {
    final newState = {...state};
    newState[room.id] = room;
    state = newState;
  }
}
