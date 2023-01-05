import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  final Function() onTap;
  final String tooltip;
  final String photo;

  const UserIcon(
      {super.key,
      required this.photo,
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
                    image: NetworkImage(photo),
                  )),
            )));
  }
}
