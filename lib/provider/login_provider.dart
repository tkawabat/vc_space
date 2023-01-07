import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/user_entity.dart';
import '../model/user_model.dart';
import '../service/snackbar_service.dart';

final loginProvider = StateNotifierProvider.autoDispose<LoginNotifer, String?>(
    (ref) => LoginNotifer());

class LoginNotifer extends StateNotifier<String?> {
  LoginNotifer() : super(null);

  void set(String? id, WidgetRef ref) {
    LoginUserNotifer loginUserNotifer = ref.read(loginUserProvider.notifier);

    state = id;
    if (id != null) {
      // Bug; navigatorが存在しないエラーが発生する
      // showSnackBar(ref.context, 'ログインしました', SnackBarType.info);
      loginUserNotifer.get(id, ref);
    } else {
      loginUserNotifer.reset();
      showSnackBar(ref.context, 'ログアウトしました', SnackBarType.info);
    }
  }
}

final loginUserProvider = StateNotifierProvider<LoginUserNotifer, UserEntity?>(
    (ref) => LoginUserNotifer());

class LoginUserNotifer extends StateNotifier<UserEntity?> {
  LoginUserNotifer() : super(null);

  Future<void> get(String id, WidgetRef ref) async {
    state = await UserModel().getUser(id);
  }

  void reset() => state = null;
}
