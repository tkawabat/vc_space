import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/room_search_provider.dart';
import '../../service/const_service.dart';
import '../l2/tag_field.dart';

class RoomSearchTagList extends HookConsumerWidget {
  RoomSearchTagList({Key? key}) : super(key: key);

  final tagKey = GlobalKey<TagFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchRoom = ref.watch(roomSearchProvider);

    return TagField(
      key: tagKey,
      samples: ConstService.sampleRoomTags,
      maxTagNumber: ConstService.maxTagLength,
      initialTags: searchRoom.tags,
      viewTitle: false,
      onChanged: (tagList) {
        ref.read(roomSearchProvider.notifier).setTags(tagList);
      },
    );
  }
}
