class TimeService {
  static final TimeService _instance = TimeService._internal();

  factory TimeService() {
    return _instance;
  }

  TimeService._internal();

  DateTime getDay(DateTime time) {
    return DateTime(time.year, time.month, time.day);
  }

  // 区切りが良い時間を返す
  DateTime getStepDateTime(DateTime time, int step) {
    final remain = time.minute % step;
    if (remain > step / 2) {
      return time.add(Duration(minutes: step - remain));
    } else {
      return time.add(Duration(minutes: -remain));
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
