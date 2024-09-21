import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class AnimatedSlogan extends StatefulWidget {
  const AnimatedSlogan({super.key});

  @override
  AnimatedSloganState createState() => AnimatedSloganState();
}

class AnimatedSloganState extends State<AnimatedSlogan>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: const AutoSizeText(
        'Your Home Deserves The Best',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 59, 36, 1),
        ),
        maxLines: 2,
      ),
    );
  }
}
