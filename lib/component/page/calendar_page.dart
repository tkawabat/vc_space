import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../entity/room_entity.dart';
import '../../entity/room_user_entity.dart';
import '../../entity/wait_time_entity.dart';
import '../../provider/room_list_join_provider.dart';
import '../../provider/wait_time_list_provider.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../../service/time_service.dart';
import '../l2/room_card.dart';
import '../l2/wait_time_card.dart';
import '../l2/wait_time_input.dart';
import '../l3/header.dart';

class CalendarPage extends StatefulHookConsumerWidget {
  final String uid;

  const CalendarPage({Key? key, required this.uid}) : super(key: key);

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime getStartTime(e) {
    if (e is RoomEntity) return e.startTime;
    if (e is WaitTimeEntity) return e.startTime;
    throw Exception('startTime Error');
  }

  Map<DateTime, List<dynamic>> getEventMap(
    List<WaitTimeEntity> waitTimeList,
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(waitTimeListProvider.notifier).getList(widget.uid);
      ref.read(roomListJoinProvider.notifier).getList(widget.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    PageService().init(context, ref);

    final waitTimeList = ref.watch(waitTimeListProvider);
    final roomList = ref.watch(roomListJoinProvider);

    final now = TimeService().getDay(DateTime.now());
    final selectedDayState = useState<DateTime>(now);
    final ValueNotifier<List> eventState = useState<List>([]);

    final eventMap = getEventMap(waitTimeList, roomList);

    // 初期選択状態を入れる
    final key = TimeService().getDay(selectedDayState.value);
    eventState.value = eventMap[key] ?? [];

    return Scaffold(
      appBar: const Header(
        title: "カレンダー",
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              headerStyle: const HeaderStyle(formatButtonVisible: false),
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
            WaitTimeInput(widget.uid),
            Expanded(
                child: ListView.builder(
              itemCount: eventState.value.length,
              itemBuilder: ((context, i) {
                if (eventState.value[i] is WaitTimeEntity) {
                  return WaitTimeCard(eventState.value[i], widget.uid);
                }
                if (eventState.value[i] is RoomEntity) {
                  return RoomCard(eventState.value[i]);
                }
                return const SizedBox();
              }),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    var waitTimeNumber = 0;
    var joinRoomNumber = 0;
    var offerRoomNumber = 0;
    for (final event in events) {
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
        _eventMarker(waitTimeNumber, Colors.black45),
        _eventMarker(joinRoomNumber, Colors.blueAccent),
        _eventMarker(offerRoomNumber, Colors.red[300]!),
      ],
    );
  }

  Widget _eventMarker(int num, Color color) {
    if (num == 0) return const SizedBox();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(num.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 12.0)),
      ),
    );
  }
}
