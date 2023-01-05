import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vc_space/component/l1/user_icon.dart';
import 'package:vc_space/service/const_design.dart';

import '../../entity/room_entity.dart';
import '../l1/tag.dart';
import '../l5/room_detail_page.dart';

class RoomCard extends StatelessWidget {
  final RoomEntity room;

  const RoomCard({super.key, required this.room});

  void onTap(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RoomDetailPage(room: room)));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(context),
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Card(
              elevation: 8,
              shadowColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: UserIcon(
                      photo: room.ownerImage,
                      tooltip: 'ユーザー情報を見る',
                      onTap: () {},
                    ),
                    title: Text(room.title),
                    trailing: buildTrailing(room),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                    alignment: Alignment.topLeft,
                    child: Wrap(
                      spacing: 2,
                      children: buildTag(room),
                    ),
                  )
                ],
              ),
            )));
  }

  Widget buildTrailing(room) {
    DateFormat formatter = DateFormat('M/d(E) HH:mm', "ja_JP");
    String start = formatter.format(room.startTime);
    String numberText = '${room.users.length}/${room.maxNumber}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('$start~'),
        SizedBox(
            width: 40,
            height: 14,
            child: Row(
              children: [
                const Icon(Icons.person, size: 18),
                Text(numberText),
              ],
            )),
      ],
    );
  }

  List<Widget> buildTag(RoomEntity room) {
    List<Widget> widgets = room.tags
        .map((text) => Tag(
              text: text,
              tagColor: ConstDesign.validTagColor,
              onTap: () {},
            ))
        .toList();

    widgets.insert(
        0,
        Tag(
          text: room.place.displayName,
          tagColor: Colors.cyan.shade100,
          onTap: () {},
        ));

    return widgets;
  }
}
