import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../entity/room_entity.dart';
import '../../model/room_model.dart';
import '../../provider/room_search_provider.dart';
import '../../service/const_service.dart';
import '../l2/room_card.dart';
import '../l2/room_search_tag_list.dart';

class RoomList extends HookConsumerWidget {
  const RoomList({Key? key}) : super(key: key);

  void Function(int) createFetchFunction(
    PagingController<int, RoomEntity> pagingController,
    RoomEntity searchRoom,
  ) {
    return (int pageKey) {
      RoomModel().getList(pageKey, searchRoom).then((list) {
        if (list.length < ConstService.listStep) {
          pagingController.appendLastPage(list);
        } else {
          pagingController.appendPage(list, pageKey + 1);
        }
      }).catchError((error) => pagingController.error = error);
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pagingState = useState<PagingController<int, RoomEntity>>(
        PagingController(firstPageKey: 0));

    final searchRoom = ref.watch(roomSearchProvider);
    final fetch = useState(createFetchFunction(pagingState.value, searchRoom));

    useEffect(
      () {
        pagingState.value.removePageRequestListener(fetch.value);
        fetch.value = createFetchFunction(pagingState.value, searchRoom);
        pagingState.value.addPageRequestListener(fetch.value);
        pagingState.value.refresh();
        return null;
      },
      [searchRoom],
    );

    return PagedSliverList(
        pagingController: pagingState.value,
        builderDelegate: PagedChildBuilderDelegate<RoomEntity>(
            animateTransitions: true,
            firstPageErrorIndicatorBuilder: (context) => Column(children: [
                  RoomSearchTagList(),
                  const SizedBox(height: 30),
                  const Center(child: Text('データ取得エラー'))
                ]),
            noItemsFoundIndicatorBuilder: (BuildContext context) =>
                Column(children: [
                  RoomSearchTagList(),
                  const SizedBox(height: 30),
                  const Center(child: Text('条件に合う部屋が存在しません'))
                ]),
            itemBuilder: (context, item, index) {
              if (index == 0) {
                return Column(children: [
                  RoomSearchTagList(),
                  const SizedBox(height: 2),
                  RoomCard(item),
                ]);
              } else {
                return RoomCard(item);
              }
            }));
  }
}
