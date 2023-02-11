import '../entity/user_entity.dart';
import '../model/user_model.dart';
import '../provider/login_provider.dart';
import 'page_service.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  bool isFollowed(UserEntity user, String targetUid) {
    return user.follows.contains(targetUid);
  }

  Future<bool> follow(String targetUid) {
    return UserModel().follow(targetUid).then((_) {
      PageService().ref!.read(loginUserProvider.notifier).follow(targetUid);
      return true;
    }).catchError((_) {
      PageService().snackbar('フォローに失敗しました', SnackBarType.error);
      return false;
    });
  }

  Future<bool> unfollow(String targetUid) {
    return UserModel().unfollow(targetUid).then((_) {
      PageService().ref!.read(loginUserProvider.notifier).unfollow(targetUid);
      return true;
    }).catchError((_) {
      PageService().snackbar('フォロー解除に失敗しました', SnackBarType.error);
      return false;
    });
  }

  bool isBlocked(UserEntity user, String targetUid) {
    // TODO
    return false;
  }
}
