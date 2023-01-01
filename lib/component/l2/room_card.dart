import 'package:flutter/material.dart';

import '../../entity/room_entity.dart';
import '../l5/room_detail_page.dart';

class RoomCard extends StatelessWidget {
  final RoomEntity room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    const colorPrimary = Colors.deepOrangeAccent;
    const colorPositive = Colors.greenAccent;
    // const colorNegative = Colors.deepOrangeAccent;

    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RoomDetailPage(room: room)));
        },
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
                    leading: ClipOval(
                      child: Container(
                        color: colorPrimary,
                        width: 48,
                        height: 48,
                        child: Center(
                          child: Text(
                            room.id!.substring(0, 1),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                    title: Text(room.title),
                    subtitle: const Text('2 min ago'),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(width: 72),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            border: Border.all(color: colorPrimary, width: 4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Flexible(child: Text('aaaaaaa')),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: colorPrimary, width: 2),
                            ),
                          ),
                          child: const Text(
                            'reason aaaaaaaaaaa',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                                // primary: colorNegative,
                                ),
                            onPressed: () {},
                            child: const Text('negative aaaaaaaaaa'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: colorPositive,
                              backgroundColor: colorPositive.withOpacity(0.2),
                            ),
                            onPressed: () {},
                            child: const Text('positive aaaaaaaa'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
