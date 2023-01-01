import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../provider/login_provider.dart';
import '../../route.dart';
import '../../entity/user_entity.dart';

import '../l2/create_room_button.dart';
import '../l2/user_icon.dart';

class Header extends HookConsumerWidget implements PreferredSizeWidget {
  final String title;

  const Header({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginUser = ref.watch(loginUserProvider);

    UserEntity user = loginUser ?? createSampleUser(); // TODO

    return AppBar(
      leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.pushNamed(context, PageNames.home.path)),
      title: Text(title),
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        const CreateRoomButton(),
        const Padding(padding: EdgeInsets.only(left: 8)),
        UserIcon(
          user: user,
        ),
        const Padding(padding: EdgeInsets.only(right: 16)),
      ],
      elevation: 0,
      // backgroundColor: Colors.transparent,
    );
  }
}
