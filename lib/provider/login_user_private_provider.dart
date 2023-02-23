import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/user_private_entity.dart';
import '../model/user_private_model.dart';

final loginUserPrivateProvider =
    StateNotifierProvider<LoginUserPrivateNotifer, UserPrivateEntity?>(
        (ref) => LoginUserPrivateNotifer());

class LoginUserPrivateNotifer extends StateNotifier<UserPrivateEntity?> {
  LoginUserPrivateNotifer() : super(null);

  Future<void> get(String uid) async {
    state = await UserPrivateModel().getByUid(uid);
  }

  void set(UserPrivateEntity? user) => state = user;
}
