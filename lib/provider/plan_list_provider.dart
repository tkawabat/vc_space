import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vc_space/service/analytics_service.dart';

import '../entity/plan_entity.dart';

final planListProvider =
    StateNotifierProvider<PlanListNotifer, List<PlanEntity>>(
        (ref) => PlanListNotifer());

class PlanListNotifer extends StateNotifier<List<PlanEntity>> {
  PlanListNotifer() : super([]);

  void set(List<PlanEntity> list) => state = list;
  void add(PlanEntity plan) {
    logEvent(LogEventName.create_plan, 'plan', 'aaa');
    state = [...state, plan];
  }
}
