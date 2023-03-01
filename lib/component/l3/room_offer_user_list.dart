import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../entity/room_entity.dart';
import '../../entity/user_entity.dart';
import '../../entity/wait_time_entity.dart';
import '../../model/wait_time_model.dart';
import '../../provider/user_search_provider.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../../service/room_service.dart';
import '../../service/wait_time_service.dart';
import '../l2/user_card.dart';
import '../l2/user_search_tag_list.dart';

class RoomOfferUserList extends HookConsumerWidget {
  final RoomEntity room;

  RoomOfferUserList(this.room, {Key? key}) : super(key: key);

  final PagingController<int, WaitTimeEntity> _pagingController =
      PagingController(firstPageKey: 0);

  void Function(int) createFetchFunction(DateTime time, UserEntity searchUser) {
    return (int pageKey) {
      WaitTimeModel()
          .getListByStartTime(pageKey, time, searchUser: searchUser)
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
              builderDelegate: PagedChildBuilderDelegate<WaitTimeEntity>(
                  animateTransitions: true,
                  firstPageErrorIndicatorBuilder: (context) =>
                      Column(children: [
                        UserSearchTagList(),
                        const SizedBox(height: 30),
                        const Center(child: Text('データ取得エラー'))
                      ]),
                  noItemsFoundIndicatorBuilder: (BuildContext context) =>
                      Column(children: [
                        UserSearchTagList(),
                        const SizedBox(height: 30),
                        const Center(child: Text('条件に合うユーザーが存在しません'))
                      ]),
                  itemBuilder: (context, item, index) {
                    if (index == 0) {
                      return Column(children: [
                        UserSearchTagList(),
                        const SizedBox(height: 2),
                        buildUserCard(item),
                      ]);
                    } else {
                      return buildUserCard(item);
                    }
                  }))),
    );
  }

  Widget buildUserCard(WaitTimeEntity waitTime) {
    return UserCard(
      waitTime.user,
      trailingOnTap: RoomService().getRoomUser(room, waitTime.uid) == null
          ? () async {
              final success = await RoomService().offer(room, waitTime.user);
              if (success) PageService().back();
            }
          : null,
      trailingButtonText:
          RoomService().isJoined(room, waitTime.uid) ? '参加済み' : '誘う',
      body: Container(
          padding: const EdgeInsets.fromLTRB(0, 4, 16, 4),
          alignment: Alignment.topRight,
          child: Text(WaitTimeService().toDisplayText(waitTime))),
    );
  }
}
