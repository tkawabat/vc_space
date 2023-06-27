import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vc_space/entity/notice_entity.dart';

import '../../entity/user_private_entity.dart';
import '../../provider/login_user_private_provider.dart';
import '../../provider/notice_list_provider.dart';

class NoticeBadge extends HookConsumerWidget {
  final Widget child;
  final AlignmentDirectional alignment;

  const NoticeBadge({
    Key? key,
    required this.child,
    this.alignment = AlignmentDirectional.topEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginUserPrivate = ref.watch(loginUserPrivateProvider);
    final noticeList = ref.watch(noticeListProvider);

    final label = createLabel(loginUserPrivate, noticeList);

    if (label == null) {
      return child;
    } else {
      return Badge(
        label: label,
        alignment: alignment,
        child: child,
      );
    }
  }

  Widget? createLabel(
    UserPrivateEntity? loginUserPrivate,
    List<NoticeEntity> noticeList,
  ) {
    if (loginUserPrivate == null) {
      return null;
    }

    final int unRead = noticeList
        .where((element) =>
            element.createdAt.isAfter(loginUserPrivate.noticeReadTime))
        .length;

    if (unRead <= 0) {
      return null;
    } else if (unRead < 10) {
      return Text(unRead.toString());
    } else {
      return const Text('9+');
    }
  }
}
