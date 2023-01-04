import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';

typedef SnackBarType = AnimatedSnackBarType;

void showSnackBar(
  BuildContext context,
  String text,
  SnackBarType type,
) {
  AnimatedSnackBar.material(
    text,
    type: type,
    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    desktopSnackBarPosition: DesktopSnackBarPosition.bottomLeft,
    duration: const Duration(seconds: 2),
  ).show(context);
}
