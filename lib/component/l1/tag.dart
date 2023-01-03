import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final Color tagColor;

  const Tag({
    super.key,
    required this.text,
    this.tagColor = Colors.black12,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Chip(
          label: Text(text),
          backgroundColor: tagColor,
        ));
  }
}
