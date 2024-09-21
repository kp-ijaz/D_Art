// import 'package:d_art/controller/controller/bottomnavbarcontroller.dart';
// import 'package:d_art/controller/controller/logincontroller.dart';
import 'package:d_art/view/modules/creatingprofile_page/controller/profile_controller.dart';
// import 'package:d_art/view/modules/profilepage/controller/userprofilepage_controller.dart';
import 'package:d_art/view/modules/splashscreen/screen/splashscreen.dart';
import 'package:d_art/view/widgets/commonwidgets/createprivacypolicy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await createPrivacyPolicy();

  Get.put(ProfileController());

  // Get.put(UserProfileController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'D ART',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
