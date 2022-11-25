import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/plan_entity.dart';

final planListProvider =
    StateNotifierProvider<PlanListNotifer, List<PlanEntity>>(
        (ref) => PlanListNotifer());

class PlanListNotifer extends StateNotifier<List<PlanEntity>> {
  PlanListNotifer() : super([]);

  void set(List<PlanEntity> list) => state = list;
  void add(PlanEntity plan) => state = [...state, plan];
}
