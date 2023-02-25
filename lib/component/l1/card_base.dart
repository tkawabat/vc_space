import 'package:flutter/material.dart';

class CardBase extends StatelessWidget {
  final List<Widget> children;
  final void Function()? onTap;

  const CardBase({super.key, required this.children, this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget widget = Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Card(
        elevation: 4,
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
