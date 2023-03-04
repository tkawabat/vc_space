import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NewWaitTime {
  int id;
  DateTimeRange range;

  NewWaitTime(this.id, this.range);
}

final waitTimeNewListProvider =
    StateNotifierProvider<WaitTimeNewStateNotifer, Map<int, NewWaitTime>>(
        (ref) => WaitTimeNewStateNotifer());

class WaitTimeNewStateNotifer extends StateNotifier<Map<int, NewWaitTime>> {
  WaitTimeNewStateNotifer() : super({});

  int newId = 0;

  Future<void> getList(String uid) async {
    // state = [];
    // state = await WaitTimeModel().getListByUid(uid);
  }

  void add(DateTimeRange range) {
    final newState = {...state};

    newState[newId] = NewWaitTime(newId, range);
    newId++;
    state = newState;
  }

  void set(int id, DateTimeRange range) {
    final newState = {...state};
    newState[id] = NewWaitTime(id, range);
    state = newState;
  }

  void delete(int id) {
    final newState = {...state};
    newState.remove(id);
    state = newState;
  }

  void deleteAll() {
    state = {};
  }
}
