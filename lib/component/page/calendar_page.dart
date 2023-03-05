import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../entity/room_entity.dart';
import '../../entity/room_user_entity.dart';
import '../../entity/wait_time_entity.dart';
import '../../provider/login_user_provider.dart';
import '../../provider/room_list_join_provider.dart';
import '../../provider/wait_time_list_provider.dart';
import '../../provider/wait_time_new_list_provider.dart';
import '../../route.dart';
import '../../service/const_design.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../../service/time_service.dart';
import '../../service/wait_time_service.dart';
import '../l1/button.dart';
import '../l1/fade.dart';
import '../l2/room_card.dart';
import '../l2/wait_time_card.dart';
import '../l2/wait_time_new_card.dart';
import '../l3/footer.dart';
import '../l3/header.dart';

class CalendarPage extends StatefulHookConsumerWidget {
  final String uid;

  const CalendarPage({Key? key, required this.uid}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends ConsumerState<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  DateTime getStartTime(e) {
    if (e is RoomEntity) return e.startTime;
    if (e is WaitTimeEntity) return e.startTime;
    if (e is NewWaitTime) return e.range.start;
    throw Exception('startTime Error');
  }

  Map<DateTime, List<dynamic>> getEventMap(
    List<WaitTimeEntity> waitTimeList,
    List<NewWaitTime> waitTimeNewList,
    List<RoomEntity> roomList,
  ) {
    final Map<DateTime, List<dynamic>> map = {};

    for (final waitTime in waitTimeList) {
      final key = TimeService().getDay(waitTime.startTime);
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(waitTime);
    }

    for (final newWaitTime in waitTimeNewList) {
      final key = TimeService().getDay(newWaitTime.range.start);
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(newWaitTime);
    }

    for (final room in roomList) {
      final key = TimeService().getDay(room.startTime);
      if (!map.containsKey(key)) {
        map[key] = [];
      }
      map[key]!.add(room);
    }

    for (final key in map.keys) {
      map[key]!.sort((a, b) => getStartTime(a).compareTo(getStartTime(b)));
    }

    return map;
  }

  @override
  void initState() {
    super.initState();

    // 他人のページ見れるようにしたとき見直す
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(waitTimeListProvider.notifier).getList(widget.uid);
      ref.read(roomListJoinProvider.notifier).getList(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    PageService().init(context, ref);

    final loginUser = ref.watch(loginUserProvider);
    final waitTimeList = ref.watch(waitTimeListProvider);
    final waitTimeNewList = ref.watch(waitTimeNewListProvider);
    final roomList = ref.watch(roomListJoinProvider);

    final now = TimeService().getDay(DateTime.now());
    final selectedDayState = useState<DateTime>(now);
    final ValueNotifier<List> eventState = useState<List>([]);

    final eventMap = getEventMap(
      waitTimeList,
      waitTimeNewList.values.toList(),
      roomList,
    );

    // 初期選択状態を入れる
    final key = TimeService().getDay(selectedDayState.value);
    eventState.value = eventMap[key] ?? [];

    final List<Widget> list = [];
    for (final event in eventState.value) {
      if (event is WaitTimeEntity) {
        list.add(WaitTimeCard(event, widget.uid));
      }
      if (event is NewWaitTime) {
        list.add(WaitTimeNewCard(event));
      }
      if (event is RoomEntity) {
        list.add(RoomCard(event));
      }
    }

    // 更新用Widgetを追加
    if (loginUser != null && loginUser.uid == widget.uid) {
      list.add(const SizedBox(height: 10));
      list.add(
        IconButton(
            onPressed: () {
              if (WaitTimeService().isMax()) {
                PageService().snackbar(
                    '誘って！は${ConstService.waitTimeMax}個までしか登録できません',
                    SnackBarType.error);
                return;
              }
              final stepNow = TimeService().getStepNow(ConstService.stepTime);
              DateTimeRange range;
              if (!now.isAtSameMomentAs(key)) {
                // 今日以外を選択中
                range = DateTimeRange(
                    start: key.copyWith(hour: 21), end: key.copyWith(hour: 23));
              } else if (stepNow.hour >= 22) {
                range = DateTimeRange(
                    start: key.copyWith(hour: 22),
                    end: key.copyWith(hour: 23, minute: 45));
              } else {
                range = DateTimeRange(
                    start: stepNow, end: stepNow.add(const Duration(hours: 2)));
              }
              ref.read(waitTimeNewListProvider.notifier).add(range);
            },
            icon: const Icon(Icons.add_outlined)),
      );
      if (waitTimeNewList.isNotEmpty) {
        list.add(Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
          child: Fade(
            child: Button(
                alignment: Alignment.centerRight,
                onTap: () => WaitTimeService()
                    .addList(loginUser, waitTimeNewList.values.toList()),
                text: '保存'),
          ),
        ));
      }
    }

    return Scaffold(
      appBar: const Header(PageNames.calendar, "予定表"),
      bottomNavigationBar: const Footer(PageNames.calendar),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              // headerStyle: const HeaderStyle(formatButtonVisible: false),
              availableCalendarFormats: const {
                // 押したら切り替えるため逆になっている
                CalendarFormat.twoWeeks: '１ヶ月',
                CalendarFormat.month: '２週間',
              },
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              firstDay: DateTime.now().add(const Duration(days: -1)),
              lastDay: DateTime.now()
                  .add(const Duration(days: ConstService.calendarMax)),
              focusedDay: selectedDayState.value,
              locale: 'ja_JP',
              selectedDayPredicate: (day) =>
                  isSameDay(selectedDayState.value, day),
              onDaySelected: (selectedDay, _) {
                selectedDayState.value = selectedDay;
                final key = TimeService().getDay(selectedDay); // timezoneの差を吸収
                eventState.value = eventMap[key] ?? [];
              },
              eventLoader: (date) {
                final key = TimeService().getDay(date); // timezoneの差を吸収
                return eventMap[key] ?? [];
              },
              calendarBuilders:
                  CalendarBuilders(markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return _buildEventsMarker(date, events);
                }
                return const SizedBox();
              }),
            ),
            Expanded(
              child: ListView(children: list),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    var newWaitTimeNumber = 0;
    var waitTimeNumber = 0;
    var joinRoomNumber = 0;
    var offerRoomNumber = 0;
    for (final event in events) {
      if (event is NewWaitTime) newWaitTimeNumber++;
      if (event is WaitTimeEntity) waitTimeNumber++;
      if (event is RoomEntity) {
        final roomUser = RoomService().getRoomUser(event, widget.uid);
        if (roomUser == null) continue;
        if (roomUser.roomUserType == RoomUserType.offer) {
          offerRoomNumber++;
        } else {
          joinRoomNumber++;
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _eventMarker(newWaitTimeNumber, ConstDesign.colorNewWaitTime),
        _eventMarker(waitTimeNumber, Colors.black45),
        _eventMarker(joinRoomNumber, Colors.blueAccent),
        _eventMarker(offerRoomNumber, Colors.red[300]!),
      ],
    );
  }

  Widget _eventMarker(int num, Color color) {
    if (num == 0) return const SizedBox();
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 12.0,
      height: 12.0,
      child: Center(
        child: Text(num.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 10.0)),
      ),
    );
  }
}
