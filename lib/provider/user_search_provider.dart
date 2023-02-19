import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/user_entity.dart';

final userSearchProvider = StateNotifierProvider<UserSearchNotifer, UserEntity>(
    (ref) => UserSearchNotifer());

class UserSearchNotifer extends StateNotifier<UserEntity> {
  UserSearchNotifer() : super(userNotFound.copyWith());

  setTags(List<String> tags) => state = state.copyWith(tags: tags);
}
