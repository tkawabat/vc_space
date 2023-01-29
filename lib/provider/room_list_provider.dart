import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/room_model.dart';
import '../service/analytics_service.dart';
import '../entity/room_entity.dart';

final roomListProvider =
    StateNotifierProvider<RoomListNotifer, List<RoomEntity>>(
        (ref) => RoomListNotifer());

class RoomListNotifer extends StateNotifier<List<RoomEntity>> {
  RoomListNotifer() : super([]);

  Future<void> get() async {
    final list = await RoomModel().getRoomList();
    state = list;
  }

  void add(RoomEntity room) {
    logEvent(LogEventName.create_room, 'room', 'aaa');
    state = [...state, room];
  }
}
