import 'package:flutter/material.dart';

class SlideAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const SlideAnimation({required this.delay, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final AnimationController controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: Scaffold.of(context),
    );

    final Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          delay,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );

    controller.forward();

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}
