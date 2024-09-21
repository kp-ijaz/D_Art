import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:d_art/presentation/bottomnav/bottomnav_bar.dart';
// import 'package:d_art/view/widgets/Loginpage/loginpage.dart';
// import 'package:d_art/view/widgets/landingPages/firstpage.dart';
import 'package:d_art/view/modules/langingpages/screen/firstpage/secondpage.dart';
// import 'package:d_art/presentation/widgets/Loginpage/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Column(
          children: [
            Lottie.asset('assets/Animation - 1716995535837.json', height: 200),
            const Text.rich(
              TextSpan(
                  text:
                      '\n    THE BEST WAY TO\nPREDICT THE FUTURE\n     IS TO DESIGN IT',
                  style: TextStyle(
                      color: Color.fromARGB(87, 255, 255, 255),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic)),
            )
          ],
        ),
      ),
      backgroundColor: const Color(0xFF1D1D9C),
      nextScreen: const HomeServiceScreen(),
      splashIconSize: 350,
      duration: 1350,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
