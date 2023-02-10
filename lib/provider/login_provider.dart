import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/user_entity.dart';
import '../model/user_model.dart';

final loginUserProvider = StateNotifierProvider<LoginUserNotifer, UserEntity?>(
    (ref) => LoginUserNotifer());

class LoginUserNotifer extends StateNotifier<UserEntity?> {
  LoginUserNotifer() : super(null);

  Future<void> get(String id) async {
    state = await UserModel().getById(id);
  }

  void set(UserEntity? user) => state = user;
}
