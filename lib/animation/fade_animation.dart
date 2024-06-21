import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class SlideAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const SlideAnimation({super.key, required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AnimProps>()
      ..add(
        AnimProps.opacity,
        Tween(begin: 0.0, end: 1.0),
        const Duration(milliseconds: 500),
        Curves.easeOut,
      )
      ..add(
        AnimProps.translateY,
        Tween(begin: 30.0, end: 0.0),
        const Duration(milliseconds: 500),
        Curves.easeOut,
      );

    return PlayAnimation<MultiTweenValues<AnimProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      builder: (context, child, value) {
        return Opacity(
          opacity: value.get(AnimProps.opacity),
          child: Transform.translate(
            offset: Offset(0, value.get(AnimProps.translateY)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

enum AnimProps { opacity, translateY }
