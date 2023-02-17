import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/room_entity.dart';

final roomSearchProvider = StateNotifierProvider<RoomSearchNotifer, RoomEntity>(
    (ref) => RoomSearchNotifer());

class RoomSearchNotifer extends StateNotifier<RoomEntity> {
  RoomSearchNotifer() : super(roomNotFound.copyWith());

  setTags(List<String> tags) => state = state.copyWith(tags: tags);
}
