import 'package:flutter/material.dart';

class CardBase extends StatelessWidget {
  final List<Widget> children;

  const CardBase(this.children, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
  }
}
