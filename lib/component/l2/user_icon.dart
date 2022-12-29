import 'package:flutter/material.dart';

import '../../entity/user_entity.dart';
import '../l5/user_page.dart';

class UserIcon extends StatelessWidget {
  final UserEntity user;

  const UserIcon({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const UserPage()));
        },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(user.photo),
              )),
        ));
  }
}
