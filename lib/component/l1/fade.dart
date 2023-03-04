import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Fade extends HookWidget {
  final Widget child;

  const Fade({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(seconds: 3),
    );

    final Animation<double> animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    useEffect(() {
      animationController.repeat();
      return null;
    }, const []);

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
