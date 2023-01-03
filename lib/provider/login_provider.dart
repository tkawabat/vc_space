import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vc_space/entity/user_entity.dart';
import 'package:vc_space/model/user_model.dart';

final loginProvider = StateNotifierProvider.autoDispose<LoginNotifer, String?>(
    (ref) => LoginNotifer());

class LoginNotifer extends StateNotifier<String?> {
  LoginNotifer() : super(null);

  void set(String? id, WidgetRef ref) {
    var loginUser = ref.read(loginUserProvider.notifier);

    state = id;
    if (id != null) {
      loginUser.get(id);
    } else {
      loginUser.reset();
    }
  }
}

final loginUserProvider = StateNotifierProvider<LoginUserNotifer, UserEntity?>(
    (ref) => LoginUserNotifer());

class LoginUserNotifer extends StateNotifier<UserEntity?> {
  LoginUserNotifer() : super(null);

  Future<void> get(String id) async {
    state = await UserModel.getUser(id);
  }

  void reset() => state = null;
}
