import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../provider/user_list_provider.dart';
import '../../route.dart';
import '../../entity/user_entity.dart';
import '../../service/page_service.dart';

import '../dialog/user_dialog.dart';
import '../l1/button.dart';
import '../l1/loading.dart';
import '../l1/twitter_link.dart';
import '../l1/user_icon.dart';
import '../l3/header.dart';

class CalendarPage extends HookConsumerWidget {
  final String userId;

  const CalendarPage({Key? key, required this.userId}) : super(key: key);

  void addTime() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    final userList = ref.watch(userListProvider);
    if (!userList.containsKey(userId)) {
      // データ取得前なら取得して待ち
      ref.read(userListProvider.notifier).get(userId);
      return const Loading();
    }
    if (userList[userId] == userNotFound) {
      // 未ログイン表示をする
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PageService().transition(PageNames.home);
        PageService().snackbar('存在しないユーザーです。', SnackBarType.error);
      });
      return const Loading();
    }

    final selectedDayState = useState<DateTime>(DateTime.now());
    final ValueNotifier<List> eventsState = useState<List>([]);

    final sampleMap = {
      DateTime.utc(2023, 2, 3): [{}, {}],
      DateTime.utc(2023, 2, 5): [{}, {}, {}, {}, {}],
    };

    return Scaffold(
      appBar: const Header(
        title: "カレンダー",
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
                headerStyle: const HeaderStyle(formatButtonVisible: false),
                firstDay: DateTime.now().add(const Duration(days: -1)),
                lastDay: DateTime.now().add(const Duration(days: 90)),
                focusedDay: selectedDayState.value,
                locale: 'ja_JP',
                selectedDayPredicate: (day) =>
                    isSameDay(selectedDayState.value, day),
                onDaySelected: (selectedDay, _) {
                  selectedDayState.value = selectedDay;
                  eventsState.value = sampleMap[selectedDay] ?? [];
                },
                eventLoader: (date) {
                  return sampleMap[date] ?? [];
                }),
            Expanded(
                child: ListView.builder(
              itemCount: eventsState.value.length + 1,
              itemBuilder: ((context, i) {
                if (i == eventsState.value.length) {
                  return IconButton(
                      tooltip: '空き時間を追加',
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline));
                }
                return Card(child: ListTile(title: Text('')));
              }),
            )),
            const SizedBox(height: 10),
            Button(
              alignment: Alignment.centerRight,
              onTap: () {},
              text: '保存',
            ),
          ],
        ),
      ),
    );
  }

  // FormBuilderField timeField() {
  //   return FormBuilderDateTimePicker(
  //     child: child
  //   )
  // }
}
