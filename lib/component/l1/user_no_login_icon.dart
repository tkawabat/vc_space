import 'package:flutter/material.dart';

class UserNoLoginIcon extends StatelessWidget {
  final Function() onTap;
  final String tooltip;

  const UserNoLoginIcon(
      {super.key, required this.onTap, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: tooltip,
        child: InkWell(
            onTap: onTap,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: const Icon(
                Icons.person,
                color: Colors.grey,
              ),
            )));
  }
}
