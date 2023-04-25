import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/room_entity.dart';
import '../../model/room_model.dart';
import '../../provider/room_search_provider.dart';
import '../l1/list_label.dart';
import '../l2/room_card.dart';

class PastRoomList extends HookConsumerWidget {
  const PastRoomList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchRoom = ref.watch(roomSearchProvider);

    return FutureBuilder(
        future: RoomModel().getPastList(0, searchRoom), // 一旦0固定
        builder: (
          BuildContext context,
          AsyncSnapshot<List<RoomEntity>> snapshot,
        ) {
          List<Widget> list = [const ListLabel('過去の部屋')];
          if (snapshot.hasError) {
            list.add(const Center(child: Text('データ取得エラー')));
          } else if (!snapshot.hasData) {
            list.add(const Center(child: Text('条件に合う部屋が存在しません')));
          } else {
            for (final room in snapshot.data!) {
              list.add(RoomCard(room));
            }
          }
          return SliverList(delegate: SliverChildListDelegate([...list]));
        });
  }
}
