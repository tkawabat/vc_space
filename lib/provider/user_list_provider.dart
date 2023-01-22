import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/user_entity.dart';
import '../model/user_model.dart';

final userListProvider =
    StateNotifierProvider<UserListNotifer, Map<String, UserEntity>>(
        (ref) => UserListNotifer());

class UserListNotifer extends StateNotifier<Map<String, UserEntity>> {
  UserListNotifer() : super({});

  void get(String userId) async {
    // 取得済みなら何もしない
    if (state.containsKey(userId)) {
      return;
    }

    UserModel().getUser(userId).then((user) {
      final newState = {...state};
      newState[userId] = user ?? userNotFound;
      state = newState;
    });
  }
}
