import '../entity/room_user_entity.dart';
import '../entity/room_entity.dart';
import '../entity/user_entity.dart';
import '../route.dart';
import '../model/room_model.dart';
import 'page_service.dart';

class RoomService {
  static final RoomService _instance = RoomService._internal();

  factory RoomService() {
    return _instance;
  }

  RoomService._internal();

  Future<bool> join(String roomId, UserEntity user) async {
    final result = await RoomModel().join(roomId, user);

    if (!result) {
      PageService().snackbar('参加できませんでした', SnackBarType.error);
      return false;
    }

    PageService().transition(PageNames.room, {'id': roomId});
    PageService().snackbar('部屋に参加しました', SnackBarType.info);

    // snapshot

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
}
