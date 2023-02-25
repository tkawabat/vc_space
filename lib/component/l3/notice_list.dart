import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../entity/notice_entity.dart';
import '../../entity/user_entity.dart';
import '../../model/notice_model.dart';
import '../../provider/login_user_provider.dart';
import '../../route.dart';
import '../../service/const_service.dart';
import '../../service/page_service.dart';
import '../l1/loading.dart';
import '../l2/notice_card.dart';

class NoticeList extends HookConsumerWidget {
  NoticeList({Key? key}) : super(key: key);

  final PagingController<int, NoticeEntity> _pagingController =
      PagingController(firstPageKey: 0);

  void Function(int) createFetchFunction(String uid) {
    return (int pageKey) {
      NoticeModel().getList(pageKey, uid).then((list) {
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
    final UserEntity? loginUser = ref.watch(loginUserProvider);
    if (loginUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        PageService().transition(PageNames.home);
      });
      return const Loading();
    }

    final fetch = useState(createFetchFunction(loginUser.uid));

    useEffect(
      () {
        _pagingController.removePageRequestListener(fetch.value);
        fetch.value = createFetchFunction(loginUser.uid);
        _pagingController.addPageRequestListener(fetch.value);
        _pagingController.refresh();
        return null;
      },
      [],
    );

    return Flexible(
      child: RefreshIndicator(
          onRefresh: () => Future.sync(
                () => _pagingController.refresh(),
              ),
          child: PagedListView(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<NoticeEntity>(
                animateTransitions: true,
                firstPageErrorIndicatorBuilder: (context) {
                  return const Center(child: Text('データ取得エラー'));
                },
                noItemsFoundIndicatorBuilder: (BuildContext context) {
                  return const Center(child: Text('条件に合う部屋が存在しません。'));
                },
                itemBuilder: (context, item, index) => NoticeCard(item),
              ))),
    );
  }
}
