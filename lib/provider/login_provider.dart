import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/user_entity.dart';
import '../model/user_model.dart';

final loginUserProvider = StateNotifierProvider<LoginUserNotifer, UserEntity?>(
    (ref) => LoginUserNotifer());

class LoginUserNotifer extends StateNotifier<UserEntity?> {
  LoginUserNotifer() : super(null);

  Future<void> get(String uid) async {
    state = await UserModel().getById(uid);
  }

  void set(UserEntity? user) => state = user;

  void follow(String uid) {
    if (state == null) return;
    final follows = [...state!.follows];
    follows.add(uid);
    state = state!.copyWith(follows: follows);
  }

  void unfollow(String uid) {
    if (state == null) return;
    final follows = [...state!.follows];
    follows.remove(uid);
    state = state!.copyWith(follows: follows);
  }
}
