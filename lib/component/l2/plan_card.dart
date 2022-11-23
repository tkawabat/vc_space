import 'package:flutter/material.dart';

import '../../entity/plan_entity.dart';

class PlanCard extends StatelessWidget {
  final PlanEntity plan;

  const PlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    // const plan = Plan('hoge', 'fuga');

    const colorPrimary = Colors.deepOrangeAccent;
    const colorPositive = Colors.greenAccent;
    // const colorNegative = Colors.deepOrangeAccent;

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Card(
          elevation: 8,
          shadowColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              ListTile(
                leading: ClipOval(
                  child: Container(
                    color: colorPrimary,
                    width: 48,
                    height: 48,
                    child: Center(
                      child: Text(
                        plan.title.substring(0, 1),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                ),
                title: Text(plan.title),
                subtitle: const Text('2 min ago'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 72),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        border: Border.all(color: colorPrimary, width: 4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Flexible(child: Text('aaaaaaa')),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: colorPrimary, width: 2),
                        ),
                      ),
                      child: const Text(
                        'reason aaaaaaaaaaa',
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            // primary: colorNegative,
                            ),
                        onPressed: () {},
                        child: const Text('negavie aaaaaaaaaa'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: colorPositive,
                          backgroundColor: colorPositive.withOpacity(0.2),
                        ),
                        onPressed: () {},
                        child: const Text('positive aaaaaaaa'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
