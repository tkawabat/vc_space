import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/plan_entity.dart';

final createPlanProvider =
    StateNotifierProvider.autoDispose<CreatePlanNotifer, PlanEntity>(
        (ref) => CreatePlanNotifer());

PlanEntity createPlan() {
  // TODO
  return createSamplePlan('test_title');
}

class CreatePlanNotifer extends StateNotifier<PlanEntity> {
  CreatePlanNotifer() : super(createPlan());

  void set(PlanEntity plan) => state = plan;
  void reset() => state = createPlan();
}
