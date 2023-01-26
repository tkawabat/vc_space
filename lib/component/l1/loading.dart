import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          color: Colors.green,
        ));
  }
}
