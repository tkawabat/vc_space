import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../entity/room_entity.dart';
import '../../model/room_model.dart';
import '../../service/const_service.dart';
import '../l2/room_card.dart';

class RoomList extends HookConsumerWidget {
  RoomList({Key? key}) : super(key: key);

  final PagingController<int, RoomEntity> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        _pagingController.addPageRequestListener((pageKey) {
          RoomModel().getList(pageKey).then((list) {
            if (list.length < ConstService.listStep) {
              _pagingController.appendLastPage(list);
            } else {
              _pagingController.appendPage(list, pageKey + 1);
            }
          }).catchError((error) => _pagingController.error = error);
        });

        return () {
          _pagingController.dispose();
        };
      },
      const [],
    );

    return Flexible(
      child: RefreshIndicator(
          onRefresh: () => Future.sync(
                () => _pagingController.refresh(),
              ),
          child: PagedListView(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<RoomEntity>(
                itemBuilder: (context, item, index) => RoomCard(item),
              ))),
    );
  }
}
