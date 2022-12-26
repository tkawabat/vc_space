import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vc_space/entity/user_entity.dart';

part 'plan_entity.freezed.dart';
part 'plan_entity.g.dart';

@freezed
class PlanEntity with _$PlanEntity {
  const factory PlanEntity(
      {required String id,
      required UserEntity owner,
      required String title,
      required String description,
      required DateTime start,
      required int maxNumber}) = _PlanEntity;

  factory PlanEntity.fromJson(Map<String, dynamic> json) =>
      _$PlanEntityFromJson(json);
}

// TODO
PlanEntity createSamplePlan(String title) {
  DateTime start = DateTime.now().add(const Duration(days: 1));
  return PlanEntity(
    id: 'id_test',
    owner: createSampleUser(),
    title: title,
    description: 'test_desc',
    start: start,
    maxNumber: 4,
  );
}
