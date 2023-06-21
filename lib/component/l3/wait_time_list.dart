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
import '../base/base_sliver_list.dart';
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

    return BaseSliverList<WaitTimeEntity>(
      pagingController: pagingState.value,
      header: const ListLabel('誘って！'),
      noDataText: '誘って！　がありません',
      rowBuilder: (WaitTimeEntity item) => UserCard(
        item.user,
        body: Container(
          padding: const EdgeInsets.fromLTRB(0, 4, 16, 4),
          alignment: Alignment.topRight,
          child: Text(WaitTimeService().toDisplayText(item)),
        ),
        trailingOnTap: trailingOnTap,
        trailingButtonText: trailingButtonText,
      ),
    );
  }
}
