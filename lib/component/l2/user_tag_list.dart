import 'package:flutter/material.dart';

import '../../entity/user_entity.dart';
import '../../service/const_design.dart';
import '../l1/tag.dart';

class UserTagList extends StatelessWidget {
  final UserEntity user;

  const UserTagList(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> list = user.tags
        .map((text) => Tag(
              text: text,
              tagColor: ConstDesign.validTagColor,
            ))
        .toList();

    if (user.tags.isEmpty) {
      list.add(const Tag(text: 'なし'));
    }

    return Wrap(spacing: 2, children: list);
  }
}
