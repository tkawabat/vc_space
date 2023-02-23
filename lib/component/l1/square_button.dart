import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? onTap;
  final Color? color;
  final Alignment alignment;

  const SquareButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
    this.color,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    Color color = this.color ?? Theme.of(context).colorScheme.secondary;

    return Align(
      alignment: alignment,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: color, width: 2),
          fixedSize: const Size(100, 100),
        ),
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text),
            const SizedBox(height: 4),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}
