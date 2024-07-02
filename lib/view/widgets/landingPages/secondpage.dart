import 'package:d_art/view/widgets/landingPages/firstpage.dart';
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
                    width: 100,
                  ),
                  const SizedBox(width: 20),
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
      child: const Text(
        'Your Home Deserves The Best',
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 59, 36, 1),
        ),
      ),
    );
  }
}

class ImageGrid extends StatelessWidget {
  const ImageGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return const GridContainer();
  }
}

class GridContainer extends StatelessWidget {
  const GridContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 9,
          itemBuilder: (BuildContext context, int index) {
            return serviceContainer(
              'assets/home_image_$index.png',
              index,
            );
          },
        ),
      ),
    );
  }
}

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
