import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../entity/room_entity.dart';
import '../../entity/room_user_entity.dart';
import '../../entity/user_entity.dart';
import '../../entity/wait_time_entity.dart';
import '../../model/room_model.dart';
import '../../model/user_model.dart';
import '../../model/wait_time_model.dart';
import '../../provider/login_user_provider.dart';
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
import '../l1/calendar_maker.dart';
import '../l1/fade.dart';
import '../l1/twitter_share_icon.dart';
import '../l2/room_card.dart';
import '../l2/wait_time_card.dart';
import '../l2/wait_time_new_card.dart';
import '../l3/footer.dart';
import '../l3/header.dart';

class CalendarPage extends HookConsumerWidget {
  final String uid;

  const CalendarPage({Key? key, required this.uid}) : super(key: key);

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
      if (waitTime.waitTimeType == WaitTimeType.noWait) continue;
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
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    // ========= provider & state ===========
    final loginUser = ref.watch(loginUserProvider);
    final waitTimeNewList = ref.watch(waitTimeNewListProvider);
    // データの再読み込みのタイミングのため
    final waitTime = ref.watch(waitTimeListProvider);

    final user = useState<UserEntity?>(null);
    final waitTimeList = useState<List<WaitTimeEntity>>([]);
    final roomList = useState<List<RoomEntity>>([]);

    final now = TimeService().today();
    final selectedDayState = useState<DateTime>(now);
    final format = useState<CalendarFormat>(CalendarFormat.twoWeeks);
    final ValueNotifier<List> eventState = useState<List>([]);

    // ========= データ取得 =============
    useEffect(() {
      UserModel()
          .getById(uid)
          .then((value) => user.value = value)
          .catchError((_) {
        PageService().snackbar('"ユーザーデータ取得エラー', SnackBarType.error);
        return null;
      });
      return null;
    }, []);
    useEffect(() {
      WaitTimeModel()
          .getListByUid(uid)
          .then((result) => waitTimeList.value = result)
          .catchError((_) {
        PageService().snackbar('"誘って！"取得エラー', SnackBarType.error);
        return [] as List<WaitTimeEntity>;
      });
      RoomModel()
          .getJoinList(uid)
          .then((result) => roomList.value = result)
          .catchError((_) {
        PageService().snackbar('部屋取得エラー', SnackBarType.error);
        return [] as List<RoomEntity>;
      });
      return null;
    }, [waitTime]);

    // ========= データ整形 ============
    final title = user.value == null ? '予定表' : '予定表 - ${user.value!.name}';
    final isViewShare = loginUser != null &&
        user.value != null &&
        loginUser.uid == user.value!.uid;
    final shareText = user.value == null
        ? '誘ってね！\n\n'
        : '${user.value!.name}の予定表です。誘ってね！\n\n';

    final eventMap = getEventMap(
      waitTimeList.value,
      waitTimeNewList.values.toList(),
      roomList.value,
    );

    // 初期選択状態を入れる
    final key = TimeService().getDay(selectedDayState.value);
    eventState.value = eventMap[key] ?? [];

    final List<Widget> list = [];
    for (final event in eventState.value) {
      if (event is WaitTimeEntity) {
        list.add(WaitTimeCard(event, uid));
      }
      if (event is NewWaitTime) {
        list.add(WaitTimeNewCard(event));
      }
      if (event is RoomEntity) {
        list.add(RoomCard(event));
      }
    }

    // ======= 自分の予定表のとき、更新用Widgetを追加 ===========
    if (loginUser != null && loginUser.uid == uid) {
      list.add(const SizedBox(height: 10));
      list.add(
        ElevatedButton.icon(
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
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
            icon: const Icon(Icons.add_outlined),
            label: const Text('誘って！')),
      );
      if (waitTimeNewList.isNotEmpty) {
        list.add(Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
          child: Fade(
            child: Button(
                alignment: Alignment.centerRight,
                onTap: () {
                  WaitTimeService()
                      .addList(loginUser, waitTimeNewList.values.toList());
                },
                text: '保存'),
          ),
        ));
      }
    }

    return Scaffold(
      appBar: Header(PageNames.calendar, title),
      bottomNavigationBar: const Footer(PageNames.calendar),
      body: Container(
        padding: const EdgeInsets.all(4),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (isViewShare)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TwitterShareIcon(
                      text: shareText,
                      url: 'calendar?uid=$uid',
                      hashtags: const ['予定表'],
                    ),
                  ),
                TableCalendar(
                  // headerStyle: const HeaderStyle(formatButtonVisible: false),
                  availableCalendarFormats: const {
                    // 押したら切り替えるため逆になっている
                    CalendarFormat.twoWeeks: '１ヶ月',
                    CalendarFormat.month: '２週間',
                  },
                  calendarFormat: format.value,
                  onFormatChanged: (value) {
                    format.value = value;
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
                    final key =
                        TimeService().getDay(selectedDay); // timezoneの差を吸収
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
                ...list,
              ]),
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
        final roomUser = RoomService().getRoomUser(event, uid);
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
        CalendarMaker(
            num: newWaitTimeNumber, color: ConstDesign.colorNewWaitTime),
        CalendarMaker(num: waitTimeNumber, color: Colors.black45),
        CalendarMaker(num: joinRoomNumber, color: Colors.blueAccent),
        CalendarMaker(num: offerRoomNumber, color: Colors.red[300]!),
      ],
    );
  }
}
