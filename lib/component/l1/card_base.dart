import 'package:flutter/material.dart';

class CardBase extends StatelessWidget {
  final List<Widget> children;
  final Color? color;
  final void Function()? onTap;

  const CardBase({super.key, required this.children, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    Widget widget = Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Card(
        elevation: 4,
        color: color,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(children: children),
      ),
    );

    if (onTap != null) {
      widget = InkWell(onTap: onTap, child: widget);
    }

    return widget;
  }
}
