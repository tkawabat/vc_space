import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final void Function() onTap;
  final void Function(String)? onTagDelete;
  final Color? tagColor;

  const Tag(
      {super.key,
      required this.text,
      this.tagColor,
      required this.onTap,
      this.onTagDelete});

  @override
  Widget build(BuildContext context) {
    List<Widget> deleteWidget = [];
    if (onTagDelete != null) {
      deleteWidget = [
        const SizedBox(width: 4.0),
        InkWell(
          child: const Icon(
            Icons.cancel,
            size: 14.0,
            color: Color.fromARGB(255, 233, 233, 233),
          ),
          onTap: () {
            onTagDelete!(text);
          },
        )
      ];
    }

    var color = tagColor ?? const Color.fromARGB(255, 74, 137, 92);

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        color: color,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onTap,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          ...deleteWidget
        ],
      ),
    );
  }
}
