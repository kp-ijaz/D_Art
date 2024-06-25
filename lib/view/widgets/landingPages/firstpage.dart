import 'package:d_art/animation/fade_animation.dart';
import 'package:d_art/controller/controller/landpagecontroller.dart';
// import 'package:d_art/view/widgets/AfterLoginPage/messagepage.dart';
import 'package:d_art/view/widgets/Loginpage/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';

class Service {
  final String name;
  final String imageURL;

  Service(this.name, this.imageURL);
}

class StartPage extends StatelessWidget {
  final _startController = Get.put(StartController());

  StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 90),
          Container(
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
              itemCount: _startController.services.length,
              itemBuilder: (BuildContext context, int index) {
                return SlideAnimation(
                  delay: (1.0 + index) / 4,
                  child: serviceContainer(
                    _startController.services[index].imageURL,
                    _startController.services[index].name,
                    index,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 30),
                SlideAnimation(
                  delay: 1.5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Center(
                      child: Text(
                        'Easy, reliable way to take \ncare of your home',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SlideAnimation(
                  delay: 1.5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: Center(
                      child: Text(
                        'We provide you with the best people to help take care of your home.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                ),
                SlideAnimation(
                  delay: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: MaterialButton(
                      elevation: 0,
                      color: Colors.black,
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      },
                      height: 55,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget serviceContainer(String image, String name, int index) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _startController.selectedService == index
              ? Colors.white
              : Colors.grey.shade100,
          border: Border.all(
            color: _startController.selectedService == index
                ? Colors.blue.shade100
                : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(image, height: 30),
            const SizedBox(height: 10),
            Text(name, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
