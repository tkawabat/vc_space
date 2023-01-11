class TimeService {
  static final TimeService _instance = TimeService._internal();

  factory TimeService() {
    return _instance;
  }

  TimeService._internal();

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
}
