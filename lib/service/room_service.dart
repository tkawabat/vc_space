import 'dart:async';

import 'package:collection/collection.dart';

import '../entity/room_user_entity.dart';
import '../entity/room_entity.dart';
import '../entity/user_entity.dart';
import '../entity/user_private_entity.dart';
import '../model/room_user_model.dart';
import '../model/room_model.dart';
import '../route.dart';
import '../provider/room_list_join_provider.dart';
import 'analytics_service.dart';
import 'page_service.dart';

class RoomService {
  static final RoomService _instance = RoomService._internal();

  factory RoomService() {
    return _instance;
  }

  RoomService._internal();

  RoomUserEntity? getRoomUser(RoomEntity room, String uid) {
    return room.users.firstWhereOrNull((element) => element.uid == uid);
  }

  bool isEnd(RoomEntity room) {
    final date = DateTime.now().add(const Duration(days: -1));
    if (room.startTime.isBefore(date)) {
      return true;
    }
    return false;
  }

  bool isClosed(RoomEntity room) {
    if (room.roomStatus.value >= RoomStatus.close.value) {
      return true;
    }
    return false;
  }

  bool isJoined(RoomEntity room, String uid) {
    return room.users.any((e) =>
        e.uid == uid &&
        [RoomUserType.admin, RoomUserType.member, RoomUserType.offer]
            .contains(e.roomUserType));
  }

  bool isCompletelyJoined(RoomEntity room, UserEntity? user) {
    if (user == null) return false;
    return room.users.any((e) =>
        e.uid == user.uid &&
        [RoomUserType.admin, RoomUserType.member].contains(e.roomUserType));
  }

  bool isOffered(RoomEntity room, UserEntity? user) {
    if (user == null) return false;
    return room.users.any((e) =>
        e.uid == user.uid && [RoomUserType.offer].contains(e.roomUserType));
  }

  String? getJoinErrorMessage(
    RoomEntity room,
    UserEntity? user,
    UserPrivateEntity? userPrivate,
  ) {
    if (isEnd(room)) return '開始時間から１日以上経過すると参加できません';
    if (isClosed(room)) return '募集終了です';
    if (user == null) return '未ログインです';
    if (isCompletelyJoined(room, user)) return '参加済みです'; // 正式参加済みならfalse
    if (room.users.length >= room.maxNumber) return '満員です';

    // ブロック中のユーザーチェック
    if (userPrivate != null &&
        room.users.any((e) => userPrivate.blocks.contains(e.uid))) {
      return 'ブロック中のユーザーが参加しているため、参加できません';
    }
    return null;
  }

  List<RoomEntity> getJoinedRoom(List<RoomEntity> roomList, String userId) {
    return roomList.where((room) => true).toList();
  }

  RoomUserEntity getAdminUser(RoomEntity room) {
    return room.users
        .where((e) => e.roomUserType == RoomUserType.admin)
        .toList()
        .first;
  }

  void enter(int roomId) {
    if (PageService().ref == null) {
      return;
    }
    PageService()
        .transition(PageNames.room, arguments: {'id': roomId.toString()});
  }

  FutureOr<bool> join(
      RoomEntity room, UserEntity user, String? password) async {
    // 参加済みだったら部屋にはいる
    if (isCompletelyJoined(room, user)) {
      enter(room.roomId);
      return true;
    }

    return RoomUserModel()
        .upsert(room.roomId, user.uid, RoomUserType.member, password)
        .then((_) {
      PageService().snackbar('部屋に参加しました', SnackBarType.info);
      PageService().ref!.read(roomListJoinProvider.notifier).add(room);
      logEvent(LogEventName.room_join, 'member', room.roomId.toString());
      enter(room.roomId);
      return true;
    }).catchError((_) {
      PageService().snackbar('部屋へ参加できませんでした', SnackBarType.error);
      return false;
    });
  }

  FutureOr<bool> quit(RoomEntity room, String uid) async {
    return RoomUserModel().delete(room.roomId, uid).then((_) {
      PageService().snackbar('部屋から脱退しました', SnackBarType.info);
      PageService().transition(PageNames.home);
      PageService()
          .ref!
          .read(roomListJoinProvider.notifier)
          .delete(room.roomId);
      logEvent(LogEventName.room_quit, 'member', room.roomId.toString());
      return true;
    }).catchError((_) {
      PageService().snackbar('部屋の脱退でエラーが発生しました', SnackBarType.error);
      return false;
    });
  }

  FutureOr<bool> kick(RoomUserEntity roomUser) async {
    final newRoomUser = roomUser.copyWith(roomUserType: RoomUserType.kick);
    return RoomUserModel().update(newRoomUser).then((_) {
      PageService().snackbar(
          '${roomUser.userData.name}さんを部屋からキックしました', SnackBarType.info);
      logEvent(LogEventName.kick, 'owner', roomUser.roomId.toString());
      return true;
    }).catchError((_) {
      PageService().snackbar('キックでエラーが発生しました', SnackBarType.error);
      return false;
    });
  }

  FutureOr<bool> offer(RoomEntity room, UserEntity user) async {
    if (isJoined(room, user.uid)) {
      PageService().snackbar('${user.name}さんは既に参加しています', SnackBarType.error);
      return false;
    }

    return RoomUserModel()
        .upsert(room.roomId, user.uid, RoomUserType.offer, '')
        .then((_) {
      PageService().snackbar('${user.name}さんを誘いました！', SnackBarType.info);
      logEvent(LogEventName.offer, 'owner', room.roomId.toString());
      return true;
    }).catchError((_) {
      PageService().snackbar('お誘いでエラーが発生しました', SnackBarType.error);
      return false;
    });
  }

  FutureOr<bool> offerStop(RoomUserEntity roomUser) async {
    return RoomUserModel().delete(roomUser.roomId, roomUser.uid).then((_) {
      PageService().snackbar(
          '${roomUser.userData.name}さんの誘いをキャンセルしました', SnackBarType.info);
      logEvent(LogEventName.offer_stop, 'owner', roomUser.roomId.toString());
      return true;
    }).catchError((_) {
      PageService().snackbar('キックでエラーが発生しました', SnackBarType.error);
      return false;
    });
  }

  FutureOr<bool> offerOk(RoomUserEntity roomUser) async {
    final newRoomUser = roomUser.copyWith(roomUserType: RoomUserType.member);
    final success = await RoomUserModel().update(newRoomUser);
    if (success) {
      PageService().snackbar('部屋に参加しました', SnackBarType.info);
      PageService()
          .ref!
          .read(roomListJoinProvider.notifier)
          .modifyUser(newRoomUser);
      logEvent(LogEventName.offer_ok, 'member', roomUser.roomId.toString());
      enter(roomUser.roomId);
    } else {
      PageService().snackbar('部屋への参加でエラーが発生しました', SnackBarType.error);
    }
    return success;
  }

  FutureOr<bool> offerNg(RoomUserEntity roomUser) async {
    return RoomUserModel().delete(roomUser.roomId, roomUser.uid).then((_) {
      PageService().snackbar('お誘いを断りました', SnackBarType.info);
      PageService()
          .ref!
          .read(roomListJoinProvider.notifier)
          .delete(roomUser.roomId);
      logEvent(LogEventName.offer_ng, 'member', roomUser.roomId.toString());
      PageService().transition(PageNames.home);
      return true;
    }).catchError((_) {
      PageService().snackbar('お誘いでエラーが発生しました', SnackBarType.error);
      return false;
    });
  }

  FutureOr<bool> updateStatus(RoomEntity room, RoomStatus status) async {
    final newObj = room.copyWith(roomStatus: status);
    return RoomModel()
        .update(newObj, targetColumnList: ['room_status']).then((_) {
      PageService().snackbar('部屋のステータスを更新しました', SnackBarType.info);
      // 入っている部屋は勝手に出ていくはず
      logEvent(
          LogEventName.room_update_status, 'owner', room.roomId.toString());
      return true;
    }).catchError((_) {
      PageService().snackbar('部屋の更新でエラーが発生しました', SnackBarType.error);
      return false;
    });
  }

  FutureOr<bool> delete(RoomEntity room) async {
    final newObj = room.copyWith(roomStatus: RoomStatus.deleted);
    return RoomModel()
        .update(newObj, targetColumnList: ['room_status']).then((_) {
      PageService().snackbar('部屋を削除しました', SnackBarType.info);
      // 入っている部屋は勝手に出ていくはず
      logEvent(LogEventName.room_delete, 'owner', room.roomId.toString());
      return true;
    }).catchError((_) {
      PageService().snackbar('部屋の削除でエラーが発生しました', SnackBarType.error);
      return false;
    });
  }
}
