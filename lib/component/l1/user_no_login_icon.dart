import 'package:flutter/material.dart';

class UserNoLoginIcon extends StatelessWidget {
  final Function()? onTap;
  final String? tooltip;

  const UserNoLoginIcon({super.key, this.onTap, this.tooltip});

  @override
  Widget build(BuildContext context) {
    Widget widget = Container(
      width: 32,
      height: 32,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      child: const Icon(
        Icons.person,
        color: Colors.grey,
      ),
    );

    if (onTap != null) {
      widget = InkWell(onTap: onTap, child: widget);
    }

    if (tooltip != null) {
      Tooltip(message: tooltip, child: widget);
    }

    return widget;
  }
}
