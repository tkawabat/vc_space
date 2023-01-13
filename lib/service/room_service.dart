import '../route.dart';
import '../model/room_model.dart';
import 'page_service.dart';

class RoomService {
  static final RoomService _instance = RoomService._internal();

  factory RoomService() {
    return _instance;
  }

  RoomService._internal();

  Future<bool> enter(String roomId, String userId) async {
    final result = await RoomModel().enter(roomId, userId);

    if (!result) {
      PageService().snackbar('入室できませんでした', SnackBarType.error);
      return false;
    }

    PageService().transition(PageNames.room, {'id': roomId});
    PageService().snackbar('入室しました', SnackBarType.info);

    // snapshot

    return true;
  }
}
