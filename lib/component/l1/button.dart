import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color? color;
  final Alignment alignment;

  const Button({
    super.key,
    required this.onTap,
    required this.text,
    this.color,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    Color color = this.color ?? Theme.of(context).colorScheme.secondary;

    return Align(
      alignment: alignment,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: const StadiumBorder(),
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}
