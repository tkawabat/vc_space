import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/search_input_entity.dart';
import '../service/time_service.dart';

final waitTimeSearchProvider =
    StateNotifierProvider<WaitTimeSearchNotifer, SearchInputEntity>(
        (ref) => WaitTimeSearchNotifer());

class WaitTimeSearchNotifer extends StateNotifier<SearchInputEntity> {
  WaitTimeSearchNotifer() : super(searchInputDefault.copyWith());

  set(SearchInputEntity newState) => state = newState;
  setTags(List<String> tags) => state = state.copyWith(tags: tags);
  setDay(DateTime time) {
    final startTime = TimeService().getDay(time);
    final endTime = startTime.copyWith(hour: 23, minute: 59);

    if (state.startTime.isAtSameMomentAs(startTime) &&
        state.endTime.isAtSameMomentAs(endTime)) return;
    state = state.copyWith(startTime: startTime, endTime: endTime);
  }
}
