import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color tagColor;

  const Tag({
    super.key,
    required this.text,
    this.tagColor = Colors.black12,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget widget = Chip(
      label: Text(text),
      backgroundColor: tagColor,
    );

    if (onTap != null) {
      widget = InkWell(
        onTap: onTap,
        child: widget,
      );
    }
    return widget;
  }
}
