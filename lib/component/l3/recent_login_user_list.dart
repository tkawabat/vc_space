import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../entity/search_input_entity.dart';
import '../../entity/user_entity.dart';
import '../../model/user_model.dart';
import '../../provider/login_user_provider.dart';
import '../../provider/wait_time_search_provider.dart';
import '../../service/const_service.dart';
import '../l1/list_label.dart';
import '../l2/user_card.dart';

class RecentLoginUserList extends HookConsumerWidget {
  final void Function(UserEntity user)? trailingOnTap;
  final String? trailingButtonText;

  const RecentLoginUserList(
      {super.key, this.trailingOnTap, this.trailingButtonText});

  void Function(int) createFetchFunction(
    PagingController<int, UserEntity> pagingController,
    SearchInputEntity searchInput,
    List<String> excludeUidList,
  ) {
    return (int pageKey) {
      UserModel()
          .getList(pageKey, searchInput, excludeUidList: excludeUidList)
          .then((list) {
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
    final pagingState = useState<PagingController<int, UserEntity>>(
        PagingController(firstPageKey: 0));
    final loginUser = ref.watch(loginUserProvider);
    final searchInput = ref.watch(waitTimeSearchProvider);

    final List<String> excludeUidList = [];
    if (loginUser != null) excludeUidList.add(loginUser.uid);
    final fetch = useState(
        createFetchFunction(pagingState.value, searchInput, excludeUidList));

    useEffect(
      () {
        pagingState.value.removePageRequestListener(fetch.value);
        fetch.value =
            createFetchFunction(pagingState.value, searchInput, excludeUidList);
        pagingState.value.addPageRequestListener(fetch.value);
        pagingState.value.refresh();
        return null;
      },
      [searchInput],
    );

    return PagedSliverList(
        pagingController: pagingState.value,
        shrinkWrapFirstPageIndicators: true,
        builderDelegate: PagedChildBuilderDelegate<UserEntity>(
            animateTransitions: true,
            firstPageErrorIndicatorBuilder: (context) =>
                const Column(children: [
                  ListLabel('直近ログイン'),
                  SizedBox(height: 30),
                  Center(child: Text('データ取得エラー')),
                  SizedBox(height: 20),
                ]),
            noItemsFoundIndicatorBuilder: (BuildContext context) =>
                const Column(children: [
                  ListLabel('直近ログイン'),
                  SizedBox(height: 30),
                  Center(child: Text('条件に合うユーザーがいません。')),
                  SizedBox(height: 20),
                ]),
            itemBuilder: (context, user, index) {
              final List<Widget> list = [];
              if (index == 0) {
                list.add(const ListLabel('直近ログイン'));
              }
              list.add(UserCard(
                user,
                trailingOnTap: trailingOnTap,
                trailingButtonText: trailingButtonText,
              ));
              return Column(children: list);
            }));
  }
}
