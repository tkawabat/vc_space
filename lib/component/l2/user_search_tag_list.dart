import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/user_search_provider.dart';
import '../../service/const_service.dart';
import '../l2/tag_field.dart';

class UserSearchTagList extends HookConsumerWidget {
  UserSearchTagList({Key? key}) : super(key: key);

  final tagKey = GlobalKey<TagFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchUser = ref.watch(userSearchProvider);

    return TagField(
      key: tagKey,
      samples: ConstService.sampleRoomTags,
      maxTagNumber: ConstService.maxTagLength,
      initialTags: searchUser.tags,
      viewTitle: false,
      onChanged: (tagList) {
        ref.read(userSearchProvider.notifier).setTags(tagList);
      },
    );
  }
}
