import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../entity/room_entity.dart';
import '../../provider/login_provider.dart';
import '../../service/room_service.dart';
import '../l1/loading.dart';
import '../l2/room_user_card.dart';

class RoomPageUser extends ConsumerWidget {
  final RoomEntity room;

  const RoomPageUser(this.room, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginUser = ref.watch(loginUserProvider);

    if (loginUser == null) {
      return const Loading();
    }

    final isAdmin = RoomService().getAdminUser(room).uid == loginUser.uid;

    final scrollController = ScrollController();
    final list = room.users.map((e) => RoomUserCard(e, isAdmin)).toList();

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ListView(
          controller: scrollController,
          children: list,
        ));
  }
}
