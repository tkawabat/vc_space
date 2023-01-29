import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/room_model.dart';

final enterRoomStreamProvider = StreamProvider.autoDispose((ref) {
  final roomId = ref.watch(enterRoomIdProvider);
  if (roomId == null) return Stream.value(null);

  return RoomModel().getRoomSnapshot(roomId);
});

final enterRoomIdProvider =
    StateNotifierProvider.autoDispose<EnterRoomIdNotifer, String?>(
        (ref) => EnterRoomIdNotifer());

class EnterRoomIdNotifer extends StateNotifier<String?> {
  EnterRoomIdNotifer() : super(null);

  void set(String? id) {
    if (state != id) state = id;
  }
}
