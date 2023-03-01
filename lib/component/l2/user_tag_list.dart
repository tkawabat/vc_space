import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/user_entity.dart';
import '../../entity/user_private_entity.dart';
import '../../provider/login_user_private_provider.dart';
import '../../service/const_design.dart';
import '../../service/user_service.dart';
import '../l1/tag.dart';

class UserTagList extends ConsumerWidget {
  final UserEntity user;
  final bool viewBlock;

  const UserTagList(this.user, {super.key, this.viewBlock = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserPrivateEntity? loginUserPrivate =
        ref.watch(loginUserPrivateProvider);

    List<Widget> list = user.tags
        .map((text) => Tag(
              text: text,
              tagColor: ConstDesign.validTagColor,
            ))
        .toList();

    if (viewBlock &&
        loginUserPrivate != null &&
        UserService().isBlocked(loginUserPrivate, user.uid)) {
      list.add(Tag(
        text: 'ブロック中',
        bold: true,
        tagColor: ConstDesign.errorTagColor,
      ));
    }

    if (user.tags.isEmpty) {
      list.add(const Tag(text: 'なし'));
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: list,
    );
  }
}
