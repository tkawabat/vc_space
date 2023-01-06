// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import '../../entity/user_entity.dart';

// class TabList extends HookConsumerWidget {
//   final List<list;
//   const TabList({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final List<types.Message> _messages = [];
//     final user = createSampleUser();

//     final chatUser = types.User(id: user.id);
//     return TabBar(
//       tabs: choices.map((Choice choice) {
//         return Tab(
//           text: choice.title,
//           icon: Icon(choice.icon),
//         );
//       }).toList(),
//     );
//   }
// }
