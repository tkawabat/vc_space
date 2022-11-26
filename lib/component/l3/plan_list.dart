import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/plan_list_provider.dart';
import '../l2/plan_card.dart';

class PlanList extends ConsumerWidget {
  const PlanList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planList = ref.watch(planListProvider);

    final scrollController = ScrollController();

    final list = planList.map((plan) => PlanCard(plan: plan)).toList();

    return Flexible(
      child: Scrollbar(
        controller: scrollController,
        child: ListView(
          controller: scrollController,
          children: list,
        ),
      ),
    );
  }
}
