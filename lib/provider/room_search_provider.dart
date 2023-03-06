import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/room_entity.dart';
import '../service/const_service.dart';
import '../service/time_service.dart';

final roomSearchProvider = StateNotifierProvider<RoomSearchNotifer, RoomEntity>(
    (ref) => RoomSearchNotifer());

class RoomSearchNotifer extends StateNotifier<RoomEntity> {
  RoomSearchNotifer()
      : super(roomNotFound.copyWith(
            startTime: TimeService().getStepDateTime(
                DateTime.now().add(const Duration(minutes: -30)),
                ConstService.stepTime)));

  set(RoomEntity room) => state = room;
  setTags(List<String> tags) => state = state.copyWith(tags: tags);
}
