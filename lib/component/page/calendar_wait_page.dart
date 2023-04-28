import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../entity/tag_count_entity.dart';
import '../../model/function_model.dart';
import '../../provider/wait_time_search_provider.dart';
import '../../route.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../../service/time_service.dart';
import '../l1/calendar_maker.dart';
import '../l2/tag_field.dart';
import '../l3/footer.dart';
import '../l3/header.dart';
import '../l3/recent_login_user_list.dart';
import '../l3/wait_time_list.dart';

class CalendarWaitPage extends HookConsumerWidget {
  const CalendarWaitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    final now = TimeService().today();
    final firstDay = DateTime.now()
        .add(const Duration(days: -1))
        .copyWith(hour: 0, minute: 0);
    final lastDay = DateTime.now()
        .add(const Duration(days: ConstService.calendarMax))
        .copyWith(hour: 23, minute: 59);

    // ========= provider ===========
    final waitTimeSearch = ref.watch(waitTimeSearchProvider);

    // =========== state ===========
    final format = useState<CalendarFormat>(CalendarFormat.twoWeeks);
    final selectedDay = useState<DateTime>(now);
    final eventMap = useState<Map<DateTime, int>>({});

    // ========= データ取得 =============
    useEffect(() {
      FunctionModel()
          .selectWaitTimeCount(
        waitTimeSearch.tags,
        firstDay,
        lastDay,
      )
          .then((List<TagCountEntity> result) {
        final Map<DateTime, int> map = {};
        for (final r in result) {
          map[r.time] = r.n;
        }
        eventMap.value = map;
      });
      return null;
    }, [waitTimeSearch.tags]);

    return Scaffold(
      appBar: const Header(PageNames.calendarWait, '待ちリスト'),
      bottomNavigationBar: const Footer(PageNames.calendarWait),
      body: Container(
        padding: const EdgeInsets.all(4),
        child: CustomScrollView(slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            TableCalendar(
              availableCalendarFormats: const {
                // 押したら切り替えるため逆になっている
                CalendarFormat.twoWeeks: '１ヶ月',
                CalendarFormat.month: '２週間',
              },
              calendarFormat: format.value,
              onFormatChanged: (value) {
                format.value = value;
              },
              firstDay: firstDay,
              lastDay: lastDay,
              focusedDay: selectedDay.value,
              locale: 'ja_JP',
              selectedDayPredicate: (day) => isSameDay(selectedDay.value, day),
              onDaySelected: (day, _) {
                final key = TimeService().getDay(day); // timezoneの差を吸収
                selectedDay.value = key;
                ref.read(waitTimeSearchProvider.notifier).setDay(key);
              },
              calendarBuilders:
                  CalendarBuilders(markerBuilder: (context, date, events) {
                final key = TimeService().getDay(date); // timezoneの差を吸収
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (eventMap.value[key] != null)
                      CalendarMaker(num: eventMap.value[key]!),
                  ],
                );
              }),
            ),
            TagField(
              samples: ConstService.sampleTagsPlay,
              maxTagNumber: 10,
              viewTitle: false,
              initialTags: const [],
              onChanged: (tags) {
                ref.read(waitTimeSearchProvider.notifier).setTags(tags);
              },
            ),
          ])),
          const WaitTimeList(),
          if (selectedDay.value.day == now.day) const RecentLoginUserList(),
        ]),
      ),
    );
  }
}
