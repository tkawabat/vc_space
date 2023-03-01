import 'package:intl/intl.dart';

import '../entity/user_entity.dart';
import '../entity/wait_time_entity.dart';
import '../model/wait_time_model.dart';
import '../provider/wait_time_list_provider.dart';
import 'const_system.dart';
import 'page_service.dart';

class WaitTimeService {
  static final WaitTimeService _instance = WaitTimeService._internal();

  factory WaitTimeService() {
    return _instance;
  }

  WaitTimeService._internal();

  String toDisplayText(WaitTimeEntity waitTime) {
    String startTime =
        DateFormat('M/d(E) HH:mm', 'ja_JP').format(waitTime.startTime);
    String endTime = DateFormat('HH:mm', 'ja_JP').format(waitTime.endTime);
    return '空き時間: $startTime 〜 $endTime';
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

  Future<bool> addNoWait(UserEntity user) {
    DateTime startTime = DateTime.now();
    DateTime endTime = startTime.add(const Duration(hours: 2));
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
