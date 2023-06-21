import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BaseSliverList<T> extends HookConsumerWidget {
  final PagingController<int, T> pagingController;
  final Widget header;
  final String noDataText;
  final Widget Function(T) rowBuilder;

  const BaseSliverList({
    required this.pagingController,
    required this.header,
    required this.noDataText,
    required this.rowBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PagedSliverList(
        pagingController: pagingController,
        shrinkWrapFirstPageIndicators: true,
        builderDelegate: PagedChildBuilderDelegate<T>(
            animateTransitions: true,
            firstPageErrorIndicatorBuilder: (context) => Column(children: [
                  header,
                  const SizedBox(height: 30),
                  const Center(child: Text('データ取得エラー')),
                  const SizedBox(height: 20),
                ]),
            noItemsFoundIndicatorBuilder: (BuildContext context) =>
                Column(children: [
                  header,
                  const SizedBox(height: 30),
                  Text(noDataText, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                ]),
            itemBuilder: (context, item, index) {
              if (index == 0) {
                return Column(children: [
                  header,
                  const SizedBox(height: 2),
                  rowBuilder(item),
                ]);
              } else {
                return rowBuilder(item);
              }
            }));
  }
}
