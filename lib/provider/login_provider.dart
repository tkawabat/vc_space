import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/user_entity.dart';
import '../model/user_model.dart';
import '../service/page_service.dart';

final loginProvider = StateNotifierProvider.autoDispose<LoginNotifer, String?>(
    (ref) => LoginNotifer());

class LoginNotifer extends StateNotifier<String?> {
  LoginNotifer() : super(null);

  void set(String? id, WidgetRef ref) {
    LoginUserNotifer loginUserNotifer = ref.read(loginUserProvider.notifier);

    bool isShowSnackbar = state != id;
    state = id;

    var message = 'ログインしました';
    if (id != null) {
      loginUserNotifer.get(id);
    } else {
      loginUserNotifer.reset();
      message = 'ログアウトしました';
    }

    if (isShowSnackbar) PageService().snackbar(message, SnackBarType.info);
  }
}

final loginUserProvider = StateNotifierProvider<LoginUserNotifer, UserEntity?>(
    (ref) => LoginUserNotifer());

class LoginUserNotifer extends StateNotifier<UserEntity?> {
  LoginUserNotifer() : super(null);

  Future<void> get(String id) async {
    state = await UserModel().getUser(id);
  }

  void reset() => state = null;
}
