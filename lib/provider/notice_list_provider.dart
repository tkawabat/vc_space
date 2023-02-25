import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/notice_entity.dart';
import '../model/notice_model.dart';
import '../service/error_service.dart';

// streamで取得しているのでjoinするカラムが取得できない
// 件数チェックにだけ使う
final noticeListProvider =
    StateNotifierProvider<NoticeListNotifer, List<NoticeEntity>>(
        (ref) => NoticeListNotifer());

class NoticeListNotifer extends StateNotifier<List<NoticeEntity>> {
  NoticeListNotifer() : super([]);

  StreamSubscription? subscription;

  Future<void> startUpdate(String uid) async {
    await stopUpdate();

    onData(List<Map<String, dynamic>> list) {
      state = list.map((e) => NoticeEntity.fromJson(e)).toList();
    }

    subscription = NoticeModel().getStream(uid).listen(onData,
        onError: ErrorService().onError(null, '', onError: () => stopUpdate()));
  }

  Future<void> stopUpdate() {
    List<Future> futureList = [];
    if (subscription != null) {
      futureList.add(subscription!.cancel());
      subscription = null;
    }
    return Future.wait(futureList).then((_) => state = []);
  }

  @override
  void dispose() async {
    await stopUpdate();
    super.dispose();
  }
}
