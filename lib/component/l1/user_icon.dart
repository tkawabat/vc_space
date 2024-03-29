import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  final Function()? onTap;
  final String? tooltip;
  final String? photo;

  const UserIcon({super.key, this.photo, this.onTap, this.tooltip});

  @override
  Widget build(BuildContext context) {
    Widget returnValue = photo == null
        ? const SizedBox(
            width: 32,
            height: 32,
            child: Icon(Icons.question_mark),
          )
        : Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(photo!),
                )),
          );

    if (onTap != null) {
      returnValue = InkWell(
        onTap: onTap,
        child: returnValue,
      );
    }

    if (tooltip != null) {
      returnValue = Tooltip(
        message: tooltip,
        child: returnValue,
      );
    }

    return returnValue;
  }
}
