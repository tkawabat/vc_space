import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/wait_time_model.dart';
import '../entity/wait_time_entity.dart';

final waitTimeListProvider =
    StateNotifierProvider<WaitTimeListNotifer, List<WaitTimeEntity>>(
        (ref) => WaitTimeListNotifer());

class WaitTimeListNotifer extends StateNotifier<List<WaitTimeEntity>> {
  WaitTimeListNotifer() : super([]);

  Future<void> getList(String uid) async {
    state = [];
    state = await WaitTimeModel().getListByUid(uid);
  }

  void add(WaitTimeEntity waitTime) {
    if (state.contains(waitTime)) return;
    final newList = [...state];
    newList.add(waitTime);
    state = newList;
  }

  void addList(List<WaitTimeEntity> list) {
    final newList = [...state];
    for (final waitTime in list) {
      if (state.contains(waitTime)) return;
      newList.add(waitTime);
    }
    state = newList;
  }

  void delete(int waitTimeId) {
    final newList = [...state];
    state = newList.where((e) => e.waitTimeId != waitTimeId).toList();
  }
}
