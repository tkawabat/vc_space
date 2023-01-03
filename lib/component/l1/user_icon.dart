import 'package:flutter/material.dart';

import '../../entity/user_entity.dart';

class UserIcon extends StatelessWidget {
  final Function() onTap;
  final String tooltip;
  final UserEntity user;

  const UserIcon(
      {super.key,
      required this.user,
      required this.onTap,
      required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: tooltip,
        child: InkWell(
            onTap: onTap,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(user.photo),
                  )),
            )));
  }
}
