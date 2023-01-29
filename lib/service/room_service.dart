import '../route.dart';
import '../entity/room_user_entity.dart';
import '../entity/room_entity.dart';
import '../entity/user_entity.dart';
import '../model/room_model.dart';
import '../provider/enter_room_stream_provider.dart';
import 'page_service.dart';

class RoomService {
  static final RoomService _instance = RoomService._internal();

  factory RoomService() {
    return _instance;
  }

  RoomService._internal();

  bool isJoined(RoomEntity room, String userId) {
    return !room.users.every((e) => e.id != userId);
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

  void enter(String roomId) {
    PageService().transition(PageNames.room, {'id': roomId});
  }

  void leave() {
    PageService().ref?.read(enterRoomIdProvider.notifier).set(null);
  }

  Future<bool> join(RoomEntity room, UserEntity user) async {
    // 未参加だったら参加する
    if (!isJoined(room, user.id)) {
      final result = await RoomModel().join(room.id, user);
      if (!result) {
        PageService().snackbar('参加できませんでした', SnackBarType.error);
        return false;
      }
      PageService().snackbar('部屋に参加しました', SnackBarType.info);
    }

    enter(room.id);

    return true;
  }
}
