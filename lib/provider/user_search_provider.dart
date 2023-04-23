import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/user_search_input_entity.dart';

final userSearchProvider =
    StateNotifierProvider<UserSearchNotifer, UserSearchInputEntity>(
        (ref) => UserSearchNotifer());

class UserSearchNotifer extends StateNotifier<UserSearchInputEntity> {
  UserSearchNotifer() : super(userSearchInputDefault.copyWith());

  set(UserSearchInputEntity userSearch) => state = userSearch;
  setTags(List<String> tags) => state = state.copyWith(tags: tags);
  setTime(DateTime time) => state = state.copyWith(time: time);
}
