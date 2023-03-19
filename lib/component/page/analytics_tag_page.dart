import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../entity/tag_count_entity.dart';
import '../../entity/user_entity.dart';
import '../../model/function_model.dart';
import '../../provider/login_user_provider.dart';
import '../../route.dart';
import '../../service/analytics_service.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../../service/time_service.dart';
import '../l2/tag_field.dart';
import '../l3/footer.dart';
import '../l3/header.dart';

class AnalyticsTagPage extends HookConsumerWidget {
  const AnalyticsTagPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    final UserEntity? loginUser = ref.watch(loginUserProvider);
    String? tag;
    if (loginUser != null && loginUser.tags.isNotEmpty) {
      tag = loginUser.tags.first;
    }

    final now = TimeService().today();
    final format = useState<CalendarFormat>(CalendarFormat.twoWeeks);
    final selectedDayState = useState<DateTime>(now);
    final selectedTag = useState<String?>(tag);

    return Scaffold(
      appBar: const Header(PageNames.analyticsTag, "誘って分析"),
      bottomNavigationBar: const Footer(PageNames.analyticsTag),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              availableCalendarFormats: const {
                // 押したら切り替えるため逆になっている
                CalendarFormat.twoWeeks: '１ヶ月',
                CalendarFormat.month: '２週間',
              },
              calendarFormat: format.value,
              onFormatChanged: (value) => format.value = value,
              firstDay: DateTime.now().add(const Duration(days: -1)),
              lastDay: DateTime.now()
                  .add(const Duration(days: ConstService.calendarMax)),
              focusedDay: selectedDayState.value,
              locale: 'ja_JP',
              selectedDayPredicate: (day) =>
                  isSameDay(selectedDayState.value, day),
              onDaySelected: (selectedDay, _) {
                selectedDayState.value = selectedDay;
              },
            ),
            Expanded(
              child: ListView(children: [
                TagField(
                  samples: ConstService.sampleTagsPlay,
                  maxTagNumber: 1,
                  viewTitle: false,
                  initialTags:
                      selectedTag.value != null ? [selectedTag.value!] : [],
                  onChanged: (tagList) {
                    if (tagList.isEmpty) {
                      selectedTag.value = null;
                    } else {
                      selectedTag.value = tagList[0];
                    }
                  },
                ),
                const SizedBox(height: 8),
                const Text('人数', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                buildChart(context, selectedTag.value, selectedDayState.value),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChart(BuildContext context, String? tag, DateTime date) {
    final color = Theme.of(context).colorScheme.secondary;
    final start = TimeService().getDay(date);
    final end = start.copyWith(hour: 23, minute: 59);
    int max = 0;

    Future<dynamic>? result;
    if (tag != null) {
      logEvent(LogEventName.analytics_tag, 'analytics', tag);
      result = FunctionModel().selectTagCount(tag, start, end);
    }

    return FutureBuilder(
        future: result,
        builder: (context, snapshot) {
          final Map<int, BarChartGroupData> chartData = {};
          if (snapshot.hasData) {
            for (var i = 0; i < 24; i++) {
              chartData[i] = (BarChartGroupData(x: i, barRods: [
                BarChartRodData(toY: 0, width: 10, color: color),
              ]));
            }
            for (final data in snapshot.data as List<TagCountEntity>) {
              final x = data.time.hour;
              if (max < data.n) max = data.n;
              chartData[x] = (BarChartGroupData(x: x, barRods: [
                BarChartRodData(
                    toY: data.n.toDouble(), width: 10, color: color),
              ]));
            }
          }

          return SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                  maxY: getMaxValue(max).toDouble(),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 36,
                          getTitlesWidget: (y, meta) {
                            if (y.floor() != y) {
                              // 整数判定
                              return const SizedBox();
                            }
                            if (y > 1000 * 1000) {
                              return Text('${y / 1000 / 1000}M');
                            } else if (y > 1000) {
                              return Text('${y / 1000}K');
                            } else {
                              return Text('$y');
                            }
                          }),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (x, meta) =>
                              x % 6 == 0 ? Text('$x:00') : const SizedBox()),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(
                      border: const Border(
                    top: BorderSide.none,
                    right: BorderSide.none,
                    left: BorderSide(width: 1),
                    bottom: BorderSide(width: 1),
                  )),
                  barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: color,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        BarTooltipItem('${group.x}:00\n${rod.toY}人',
                            const TextStyle(color: Colors.white)),
                  )),
                  barGroups: chartData.values.toList()),
            ),
          );
        });
  }

  // y軸の最大値をいい感じにする
  int getMaxValue(int value) {
    int order = value.toString().length;
    if (order <= 1) {
      return 10;
    }
    final top2value = value ~/ pow(10, order - 2);
    return (top2value + 2 - top2value % 2) * pow(10, order - 2) as int;
  }
}
