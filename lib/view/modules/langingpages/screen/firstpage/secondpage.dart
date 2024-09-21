// import 'package:auto_size_text/auto_size_text.dart';
import 'package:d_art/view/modules/langingpages/screen/firstpage/animatedtext.dart';
import 'package:d_art/view/modules/langingpages/screen/firstpage/gridcontainer.dart';
import 'package:d_art/view/modules/langingpages/screen/secondpage/firstpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeServiceScreen extends StatelessWidget {
  const HomeServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: HomeServiceContent(),
    );
  }
}

class HomeServiceContent extends StatefulWidget {
  const HomeServiceContent({super.key});

  @override
  HomeServiceContentState createState() => HomeServiceContentState();
}

class HomeServiceContentState extends State<HomeServiceContent>
    with TickerProviderStateMixin {
  late AnimationController _moveUpController;
  late AnimationController _fadeInGridController;
  late Animation<Offset> _moveUpAnimation;
  late Animation<double> _fadeInGridAnimation;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();

    _moveUpController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _moveUpAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.34),
    ).animate(
      CurvedAnimation(
        parent: _moveUpController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeInGridController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeInGridAnimation = CurvedAnimation(
      parent: _fadeInGridController,
      curve: Curves.easeIn,
    );

    Future.delayed(const Duration(seconds: 2), () {
      _moveUpController.forward().then((_) {
        _fadeInGridController.forward().then((_) {
          setState(() {
            _showButton = true;
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _moveUpController.dispose();
    _fadeInGridController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideTransition(
          position: _moveUpAnimation,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/home-service-logo1.png',
                    width: Get.width * 0.2,
                  ),
                  SizedBox(width: Get.width * 0.025),
                  const Expanded(child: AnimatedSlogan()),
                ],
              ),
            ),
          ),
        ),
        FadeTransition(
          opacity: _fadeInGridAnimation,
          child: const Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ImageGrid(),
            ),
          ),
        ),
        if (_showButton)
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Get.off(() => StartPage());
              },
              icon: const Icon(Icons.arrow_forward_ios_outlined),
              label: const Text('Next'),
            ),
          ),
      ],
    );
  }
}

Widget serviceContainer(String imagePath, int index) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(),
      borderRadius: BorderRadius.circular(8),
      image: DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.cover,
      ),
    ),
  );
}
