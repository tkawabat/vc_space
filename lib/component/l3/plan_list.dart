import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/plan_list_provider.dart';
import '../l2/plan_card.dart';

class PlanList extends HookConsumerWidget {
  const PlanList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planList = ref.watch(planListProvider);

    final list = planList.map((plan) => PlanCard(plan: plan)).toList();
    // final list = [PlanCard(plan: planList[0])];

    return ListView(
      children: list,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
