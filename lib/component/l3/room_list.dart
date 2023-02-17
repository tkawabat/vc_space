import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../entity/room_entity.dart';
import '../../model/room_model.dart';
import '../../provider/room_search_provider.dart';
import '../../service/const_service.dart';
import '../l2/room_card.dart';

class RoomList extends HookConsumerWidget {
  RoomList({Key? key}) : super(key: key);

  final PagingController<int, RoomEntity> _pagingController =
      PagingController(firstPageKey: 0);

  void Function(int) factoryFetch(searchRoom) {
    return (int pageKey) {
      RoomModel().getList(pageKey, tags: searchRoom.tags).then((list) {
        if (list.length < ConstService.listStep) {
          _pagingController.appendLastPage(list);
        } else {
          _pagingController.appendPage(list, pageKey + 1);
        }
      }).catchError((error) => _pagingController.error = error);
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchRoom = ref.watch(roomSearchProvider);
    final fetch = useState(factoryFetch(searchRoom));

    useEffect(
      () {
        _pagingController.removePageRequestListener(fetch.value);
        fetch.value = factoryFetch(searchRoom);
        _pagingController.addPageRequestListener(fetch.value);
        _pagingController.refresh();
        return null;
      },
      [searchRoom],
    );

    return Flexible(
      child: RefreshIndicator(
          onRefresh: () => Future.sync(
                () => _pagingController.refresh(),
              ),
          child: PagedListView(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<RoomEntity>(
                animateTransitions: true,
                firstPageErrorIndicatorBuilder: (context) {
                  return const Center(child: Text('hoge'));
                },
                noItemsFoundIndicatorBuilder: (BuildContext context) {
                  return const Center(child: Text('部屋が存在しません。'));
                },
                itemBuilder: (context, item, index) => RoomCard(item),
              ))),
    );
  }
}
