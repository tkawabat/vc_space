import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../service/const_service.dart';

class BaseSingleList<T> extends HookConsumerWidget {
  final Future<List<T>> Function(int) fetchFunction;
  final String noDataText;
  final Widget Function(T) rowBuilder;
  final dynamic refresher;

  const BaseSingleList({
    super.key,
    required this.fetchFunction,
    required this.rowBuilder,
    required this.noDataText,
    this.refresher,
  });

  dynamic listenerBuilder(
    PagingController<int, T> pagingController,
    Future<List<T>> Function(int) fetchFunction,
  ) {
    return (int pageKey) {
      fetchFunction(pageKey).then((list) {
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
    final pagingState =
        useState<PagingController<int, T>>(PagingController(firstPageKey: 0));
    final listenerState =
        useState(listenerBuilder(pagingState.value, fetchFunction));

    useEffect(
      () {
        pagingState.value.removePageRequestListener(listenerState.value);
        listenerState.value = listenerBuilder(pagingState.value, fetchFunction);
        pagingState.value.addPageRequestListener(listenerState.value);
        pagingState.value.refresh();
        return null;
      },
      [refresher],
    );

    return Flexible(
      child: RefreshIndicator(
          onRefresh: () => Future.sync(
                () => pagingState.value.refresh(),
              ),
          child: PagedListView(
              pagingController: pagingState.value,
              builderDelegate: PagedChildBuilderDelegate<T>(
                animateTransitions: true,
                firstPageErrorIndicatorBuilder: (context) {
                  return const Text('データ取得エラー', textAlign: TextAlign.center);
                },
                noItemsFoundIndicatorBuilder: (context) {
                  return Text(noDataText, textAlign: TextAlign.center);
                },
                itemBuilder: (context, item, index) => rowBuilder(item),
              ))),
    );
  }
}
