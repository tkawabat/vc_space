import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/room_entity.dart';
import '../../service/page_service.dart';
import '../l3/header.dart';
import '../l3/vc_chat.dart';

class RoomDetailPage extends HookConsumerWidget {
  const RoomDetailPage({Key? key, required this.room}) : super(key: key);

  final RoomEntity room;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    PageService().init(context, ref);

    final tabList = ['チャット', '部屋情報', '参加者'];

    return DefaultTabController(
        length: tabList.length,
        child: Scaffold(
          appBar: Header(
            title: room.title,
            bottom:
                TabBar(tabs: tabList.map((text) => Tab(text: text)).toList()),
          ),
          body: TabBarView(children: [
            Column(children: const [Expanded(child: VCChat())]),
            // Column(
            //   children: [
            //     ElevatedButton(
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //       child: const Text('戻る'),
            //     ),
            //   ],
            // ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('戻る'),
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('戻る'),
                ),
              ],
            ),
          ]),
        ));
  }
}
