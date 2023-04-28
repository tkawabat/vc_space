class TimeService {
  static final TimeService _instance = TimeService._internal();

  factory TimeService() {
    return _instance;
  }

  TimeService._internal();

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime today() {
    return getDay(DateTime.now());
  }

  DateTime getDay(DateTime time) {
    return DateTime(time.year, time.month, time.day);
  }

  // 区切りが良い時間を返す
  DateTime getStepDateTime(DateTime time, int step) {
    DateTime returnValue = time.copyWith(
      second: 0,
      millisecond: 0,
      microsecond: 0,
    );
    final remain = returnValue.minute % step;
    if (remain > step / 2) {
      return returnValue.add(Duration(minutes: step - remain));
    } else {
      return returnValue.add(Duration(minutes: -remain));
    }
  }

  DateTime getStepNow(int step) {
    return getStepDateTime(DateTime.now(), step);
  }

  String getAgoString(DateTime time) {
    final Duration diff = DateTime.now().difference(time);
    if (diff.inDays > 0) return '${diff.inDays}日前';
    if (diff.inHours > 0) return '${diff.inHours}時間前';
    if (diff.inMinutes > 0) return '${diff.inMinutes}分前';
    return '${diff.inSeconds}秒前';
  }
}
