import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/room_entity.dart';
import '../../model/room_model.dart';
import '../../provider/room_search_provider.dart';
import '../base/base_sliver_list.dart';
import '../l2/room_card.dart';
import '../l2/room_search_tag_list.dart';

class RoomList extends HookConsumerWidget {
  const RoomList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchRoom = ref.watch(roomSearchProvider);

    return BaseSliverList<RoomEntity>(
      fetchFunction: (int pageKey) => RoomModel().getList(pageKey, searchRoom),
      header: RoomSearchTagList(),
      noDataText: '条件に合う部屋がありません。\n部屋を作って、お誘いしましょう！',
      rowBuilder: (RoomEntity item) => RoomCard(item),
      refresher: searchRoom,
    );
  }
}
