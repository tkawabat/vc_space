import 'dart:async';

import 'package:collection/collection.dart';

import '../route.dart';
import '../entity/room_user_entity.dart';
import '../entity/room_entity.dart';
import '../entity/user_entity.dart';
import '../entity/user_private_entity.dart';
import '../model/room_user_model.dart';
import '../provider/room_list_join_provider.dart';
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

  bool canJoin(
      RoomEntity room, UserEntity? user, UserPrivateEntity? userPrivate) {
    if (user == null) return false;
    if (isCompletelyJoined(room, user)) return false; // 正式参加済みならfalse
    if (room.users.length >= room.maxNumber) return false;

    // ブロック中のユーザーがいないかチェック
    if (userPrivate != null &&
        room.users.any((e) => userPrivate.blocks.contains(e.uid))) {
      return false;
    }
    return true;
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
        .insert(room.roomId, user.uid, RoomUserType.member, password)
        .then((_) {
      PageService().snackbar('部屋に参加しました', SnackBarType.info);
      PageService().ref!.read(roomListJoinProvider.notifier).add(room);
      enter(room.roomId);
      return true;
    }).catchError((_) {
      PageService().snackbar('部屋へ参加できませんでした', SnackBarType.error);
      return false;
    });
  }

  FutureOr<bool> quit(RoomEntity room, String uid) async {
    final success = await RoomUserModel().delete(room.roomId, uid);
    if (success) {
      PageService().snackbar('部屋から脱退しました', SnackBarType.info);
      PageService().transition(PageNames.home);
      PageService()
          .ref!
          .read(roomListJoinProvider.notifier)
          .delete(room.roomId);
    } else {
      PageService().snackbar('部屋の脱退でエラーが発生しました', SnackBarType.error);
    }
    return success;
  }

  FutureOr<bool> kick(RoomUserEntity roomUser) async {
    final newRoomUser = roomUser.copyWith(roomUserType: RoomUserType.kick);
    final success = await RoomUserModel().update(newRoomUser);
    if (success) {
      PageService().snackbar(
          '${roomUser.userData.name}さんを部屋からキックしました', SnackBarType.info);
    } else {
      PageService().snackbar('キックでエラーが発生しました', SnackBarType.error);
    }
    return success;
  }

  FutureOr<bool> offer(RoomEntity room, UserEntity user) async {
    if (isJoined(room, user.uid)) {
      PageService().snackbar('${user.name}さんは既に参加しています', SnackBarType.error);
      return false;
    }

    return RoomUserModel()
        .insert(room.roomId, user.uid, RoomUserType.offer, '')
        .then((_) {
      PageService().snackbar('${user.name}さんを誘いました！', SnackBarType.info);
      return true;
    }).catchError((_) {
      PageService().snackbar('オファーでエラーが発生しました', SnackBarType.error);
      return false;
    });
  }

  FutureOr<bool> offerStop(RoomUserEntity roomUser) async {
    return RoomUserModel().delete(roomUser.roomId, roomUser.uid).then((_) {
      PageService().snackbar(
          '${roomUser.userData.name}さんの誘いをキャンセルしました', SnackBarType.info);
      return true;
    }).catchError((_) {
      PageService().snackbar('キックでエラーが発生しました', SnackBarType.error);
      return false;
    });
  }
}
