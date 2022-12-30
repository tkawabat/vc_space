import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final Color? tagColor;

  const Tag({
    super.key,
    required this.text,
    this.tagColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color color = tagColor ?? Colors.black12;

    return InkWell(
        onTap: onTap,
        child: Chip(
          label: Text(text),
          backgroundColor: color,
        ));
  }
}
