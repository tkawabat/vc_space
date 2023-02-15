import 'dart:async';

import 'package:collection/collection.dart';

import '../route.dart';
import '../entity/room_user_entity.dart';
import '../entity/room_entity.dart';
import '../entity/user_entity.dart';
import '../model/room_user_model.dart';
import 'page_service.dart';

class RoomService {
  static final RoomService _instance = RoomService._internal();

  factory RoomService() {
    return _instance;
  }

  RoomService._internal();

  RoomUserEntity? getOwnRoomUser(RoomEntity room, String uid) {
    return room.users.firstWhereOrNull((element) => element.uid == uid);
  }

  bool isJoined(RoomEntity room, String userId) {
    return room.users.any((e) =>
        e.uid == userId &&
        [RoomUserType.admin, RoomUserType.member].contains(e.roomUserType));
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

  RoomUserEntity? getRoomUser(RoomEntity room, String uid) {
    return room.users.firstWhere((element) => element.uid == uid);
  }

  void enter(int roomId) {
    if (PageService().ref == null) {
      return;
    }
    PageService()
        .transition(PageNames.room, arguments: {'id': roomId.toString()});
  }

  Future<bool> join(RoomEntity room, UserEntity user, String? password) async {
    // 未参加だったら参加する
    if (!isJoined(room, user.uid)) {
      final result = await RoomUserModel()
          .insert(room.roomId, user.uid, RoomUserType.member, password);
      if (!result) {
        PageService().snackbar('参加できませんでした', SnackBarType.error);
        return false;
      }
      PageService().snackbar('部屋に参加しました', SnackBarType.info);
      // TODO ステートにも自分を追加する
    }

    enter(room.roomId);

    return true;
  }

  FutureOr<bool> quit(int roomId, String uid) async {
    final success = await RoomUserModel().delete(roomId, uid);
    if (success) {
      PageService().snackbar('部屋から脱退しました', SnackBarType.info);
      PageService().transition(PageNames.home, replace: true);
    } else {
      PageService().snackbar('部屋からの脱退でエラーが発生しました', SnackBarType.error);
    }
    // TODO ステートから自分を外す
    return success;
  }
}
