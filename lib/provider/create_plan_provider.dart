import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/plan_entity.dart';
import '../entity/user_entity.dart';

final createPlanProvider = StateNotifierProvider<CreatePlanNotifer, PlanEntity>(
    (ref) => CreatePlanNotifer());

PlanEntity createPlan() {
  DateTime start = DateTime.now().add(const Duration(days: 1));
  UserEntity owner = const UserEntity('user01', '太郎');
  return PlanEntity('id_test', owner, 'title_test', 'desc_test', start, 4);
}

class CreatePlanNotifer extends StateNotifier<PlanEntity> {
  CreatePlanNotifer() : super(createPlan());

  void set(PlanEntity plan) => state = plan;
  void reset() => state = createPlan();
}
