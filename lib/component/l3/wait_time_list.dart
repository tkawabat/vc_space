import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../entity/search_input_entity.dart';
import '../../entity/user_entity.dart';
import '../../entity/wait_time_entity.dart';
import '../../model/wait_time_model.dart';
import '../../provider/wait_time_search_provider.dart';
import '../../service/const_service.dart';
import '../../service/wait_time_service.dart';
import '../l1/list_label.dart';
import '../l2/user_card.dart';

class WaitTimeList extends HookConsumerWidget {
  final void Function(UserEntity user)? trailingOnTap;
  final String? trailingButtonText;
  final List<String> excludeUidList;

  const WaitTimeList({
    super.key,
    this.trailingOnTap,
    this.trailingButtonText,
    this.excludeUidList = const [],
  });

  void Function(int) createFetchFunction(
    PagingController<int, WaitTimeEntity> pagingController,
    SearchInputEntity searchInput,
  ) {
    return (int pageKey) {
      WaitTimeModel().getList(pageKey, searchInput).then((list) {
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
    final pagingState = useState<PagingController<int, WaitTimeEntity>>(
        PagingController(firstPageKey: 0));

    final searchInput = ref.watch(waitTimeSearchProvider);
    final fetch = useState(createFetchFunction(pagingState.value, searchInput));

    useEffect(
      () {
        pagingState.value.removePageRequestListener(fetch.value);
        fetch.value = createFetchFunction(pagingState.value, searchInput);
        pagingState.value.addPageRequestListener(fetch.value);
        pagingState.value.refresh();
        return null;
      },
      [searchInput],
    );

    return PagedSliverList(
        pagingController: pagingState.value,
        shrinkWrapFirstPageIndicators: true,
        builderDelegate: PagedChildBuilderDelegate<WaitTimeEntity>(
            animateTransitions: true,
            firstPageErrorIndicatorBuilder: (context) =>
                const Column(children: [
                  ListLabel('誘って！'),
                  SizedBox(height: 30),
                  Center(child: Text('データ取得エラー')),
                  SizedBox(height: 20),
                ]),
            noItemsFoundIndicatorBuilder: (BuildContext context) =>
                const Column(children: [
                  ListLabel('誘って！'),
                  SizedBox(height: 30),
                  Center(child: Text('誘って！　がありません')),
                  SizedBox(height: 20),
                ]),
            itemBuilder: (context, waitTime, index) {
              final List<Widget> list = [];
              if (index == 0) {
                list.add(const ListLabel('誘って！'));
              }
              list.add(UserCard(
                waitTime.user,
                body: Container(
                  padding: const EdgeInsets.fromLTRB(0, 4, 16, 4),
                  alignment: Alignment.topRight,
                  child: Text(WaitTimeService().toDisplayText(waitTime)),
                ),
                trailingOnTap: trailingOnTap,
                trailingButtonText: trailingButtonText,
              ));
              return Column(children: list);
            }));
  }
}
