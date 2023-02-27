import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../entity/room_entity.dart';
import '../../entity/user_entity.dart';
import '../../model/user_model.dart';
import '../../provider/user_search_provider.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../l2/user_card.dart';

class RoomOfferUserList extends HookConsumerWidget {
  final RoomEntity room;

  RoomOfferUserList(this.room, {Key? key}) : super(key: key);

  final PagingController<int, UserEntity> _pagingController =
      PagingController(firstPageKey: 0);

  void Function(int) createFetchFunction(DateTime time, UserEntity searchUser) {
    return (int pageKey) {
      UserModel()
          .getListByWaitTime(pageKey, time, searchUser: searchUser)
          .then((list) {
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
    final searchUser = ref.watch(userSearchProvider);
    final fetch = useState(createFetchFunction(room.startTime, searchUser));

    useEffect(
      () {
        _pagingController.removePageRequestListener(fetch.value);
        fetch.value = createFetchFunction(room.startTime, searchUser);
        _pagingController.addPageRequestListener(fetch.value);
        _pagingController.refresh();
        return null;
      },
      [searchUser],
    );

    return Flexible(
      child: RefreshIndicator(
          onRefresh: () => Future.sync(
                () => _pagingController.refresh(),
              ),
          child: PagedListView(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<UserEntity>(
                animateTransitions: true,
                firstPageErrorIndicatorBuilder: (context) {
                  return const Center(child: Text('データ取得エラー'));
                },
                noItemsFoundIndicatorBuilder: (BuildContext context) {
                  return const Center(child: Text('条件に合うユーザーが存在しません'));
                },
                itemBuilder: (context, item, index) => UserCard(
                  item,
                  trailingOnTap: RoomService().getRoomUser(room, item.uid) ==
                          null
                      ? () async {
                          final success = await RoomService().offer(room, item);
                          if (success) PageService().back();
                        }
                      : null,
                  trailingButtonText:
                      RoomService().isJoined(room, item.uid) ? '参加済み' : '誘う',
                ),
              ))),
    );
  }
}
