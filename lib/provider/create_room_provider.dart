import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/room_entity.dart';

final createRoomProvider =
    StateNotifierProvider.autoDispose<CreateRoomNotifer, RoomEntity>(
        (ref) => CreateRoomNotifer());

RoomEntity createRoom() {
  // TODO
  return createSampleRoom('test_title');
}

class CreateRoomNotifer extends StateNotifier<RoomEntity> {
  CreateRoomNotifer() : super(createRoom());

  void set(RoomEntity room) => state = room;
  void reset() => state = createRoom();
}
