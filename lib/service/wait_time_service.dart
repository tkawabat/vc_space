import 'package:intl/intl.dart';

import '../entity/user_entity.dart';
import '../entity/wait_time_entity.dart';
import '../model/wait_time_model.dart';
import '../provider/wait_time_list_provider.dart';
import '../provider/wait_time_new_list_provider.dart';
import 'const_system.dart';
import 'const_service.dart';
import 'page_service.dart';

class WaitTimeService {
  static final WaitTimeService _instance = WaitTimeService._internal();

  factory WaitTimeService() {
    return _instance;
  }

  WaitTimeService._internal();

  String toDisplayText(WaitTimeEntity waitTime) {
    String startTime =
        DateFormat('M/d(E)  HH:mm', 'ja_JP').format(waitTime.startTime);
    String endTime = DateFormat('HH:mm', 'ja_JP').format(waitTime.endTime);
    return '誘って！ $startTime 〜 $endTime';
  }

  bool isMax() {
    final waitTimeList = PageService().ref!.read(waitTimeListProvider);
    final waitTimeNewList = PageService().ref!.read(waitTimeNewListProvider);

    final n =
        waitTimeList.where((e) => e.waitTimeType == WaitTimeType.valid).length;
    return n + waitTimeNewList.length >= ConstService.waitTimeMax;
  }

  bool isViewDialog() {
    final waitTimeList = PageService().ref!.read(waitTimeListProvider);
    return waitTimeList.every((e) {
      if (e.waitTimeType == WaitTimeType.noWait) return false;
      final now = DateTime.now();
      //　一時間ずつ猶予を入れる
      if (now.isAfter(e.startTime.add(const Duration(hours: -1))) &&
          now.isBefore(e.endTime.add(const Duration(hours: 1)))) return false;
      return true;
    });
  }

  Future<bool> add(UserEntity user, DateTime startTime, DateTime endTime) {
    WaitTimeEntity waitTime = WaitTimeEntity(
      uid: user.uid,
      waitTimeId: ConstSystem.idBeforeInsert,
      waitTimeType: WaitTimeType.valid,
      startTime: startTime,
      endTime: endTime,
      updatedAt: DateTime.now(),
      user: user,
    );

    return WaitTimeModel().insert(waitTime).then((waitTime) {
      if (waitTime == null) throw Exception;
      PageService().ref!.read(waitTimeListProvider.notifier).add(waitTime);
      PageService().snackbar('空き時間を登録しました', SnackBarType.info);
      return true;
    }).catchError((_) {
      PageService().snackbar('空き時間の登録に失敗しました', SnackBarType.error);
      return false;
    });
  }

  Future<bool> addList(UserEntity user, List<NewWaitTime> newWaitTimeList) {
    final list = newWaitTimeList
        .map((e) => WaitTimeEntity(
            uid: user.uid,
            waitTimeId: ConstSystem.idBeforeInsert,
            waitTimeType: WaitTimeType.valid,
            startTime: e.range.start,
            endTime: e.range.end,
            updatedAt: DateTime.now(),
            user: user))
        .toList();
    return WaitTimeModel().insertList(list).then((value) {
      PageService().ref!.read(waitTimeListProvider.notifier).addList(value);
      PageService().ref!.read(waitTimeNewListProvider.notifier).deleteAll();
      PageService().snackbar('空き時間を登録しました', SnackBarType.info);
      return true;
    }).catchError((_) {
      PageService().snackbar('空き時間の登録に失敗しました', SnackBarType.error);
      return false;
    });
  }

  Future<bool> addNoWait(UserEntity user) {
    DateTime startTime = DateTime.now();
    DateTime endTime = startTime;
    WaitTimeEntity waitTime = WaitTimeEntity(
      uid: user.uid,
      waitTimeId: ConstSystem.idBeforeInsert,
      waitTimeType: WaitTimeType.noWait,
      startTime: startTime,
      endTime: endTime,
      updatedAt: DateTime.now(),
      user: user,
    );

    return WaitTimeModel().insert(waitTime).then((waitTime) {
      if (waitTime == null) throw Exception;
      PageService().ref!.read(waitTimeListProvider.notifier).add(waitTime);
      return true;
    }).catchError((_) {
      return false;
    });
  }

  Future<bool> delete(String uid, int waitTimeId) {
    return WaitTimeModel().delete(uid, waitTimeId).then((_) {
      PageService().ref!.read(waitTimeListProvider.notifier).delete(waitTimeId);
      return true;
    }).catchError((_) {
      PageService().snackbar('空き時間の削除に失敗しました', SnackBarType.error);
      return false;
    });
  }
}
