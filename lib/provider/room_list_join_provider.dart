import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/room_model.dart';
import '../entity/room_entity.dart';

final roomListJoinProvider =
    StateNotifierProvider<RoomListJoinNotifer, List<RoomEntity>>(
        (ref) => RoomListJoinNotifer());

class RoomListJoinNotifer extends StateNotifier<List<RoomEntity>> {
  RoomListJoinNotifer() : super([]);

  Future<void> getList(String uid) async {
    state = [];
    state = await RoomModel().getJoinList(uid);
  }

  void add(RoomEntity room) {
    if (state.contains(room)) return;
    final newList = [...state];
    newList.add(room);
    state = newList;
  }

  void delete(int roomId) {
    final newList = [...state];
    state = newList.where((e) => e.roomId != roomId).toList();
  }
}
