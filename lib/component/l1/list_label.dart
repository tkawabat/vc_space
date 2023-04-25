import 'package:flutter/material.dart';

import '../../service/const_design.dart';

class ListLabel extends StatelessWidget {
  final String text;

  const ListLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 32, left: 16, bottom: 8),
      child: Text(text, style: ConstDesign.h3),
    );
  }
}
