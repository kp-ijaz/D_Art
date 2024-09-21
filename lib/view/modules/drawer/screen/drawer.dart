import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/view/modules/bottomnavbar/controller/bottomnavbarcontroller.dart';
import 'package:d_art/view/modules/drawer/widgets/privacypolicy.dart';
import 'package:d_art/view/modules/register_serviceprovider/screen/registeration.dart';
import 'package:d_art/view/modules/drawer/widgets/widgets.dart';
import 'package:d_art/view/modules/loginpage/screen/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyDrawer extends StatelessWidget {
  final BottomNavBarController bottomController =
      Get.find<BottomNavBarController>();
  final BottomNavBaruserController usercontroller =
      Get.put(BottomNavBaruserController());
  MyDrawer({super.key});

  Future<bool> isServiceProvider() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      return data['isServiceProvider'] ?? false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey,
      child: FutureBuilder<bool>(
        future: isServiceProvider(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          bool isServiceProvider = snapshot.data ?? false;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const DrawerHeader(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                  MyListTile(
                      icon: Icons.home,
                      text: 'HOME',
                      onTap: () => Get.off(() => bottomController)),
                  MyListTile(
                    icon: isServiceProvider
                        ? Icons.verified
                        : Icons.app_settings_alt_rounded,
                    text: isServiceProvider
                        ? 'YOU HAVE ALREADY REGISTERED'
                        : 'REGISTER AS SERVICE PROVIDER',
                    onTap: isServiceProvider
                        ? () => Get.back()
                        : () => Get.off(() => VerificationScreen()),
                  ),
                  MyListTile(
                      icon: Icons.privacy_tip,
                      text: 'Privacy & policy',
                      onTap: () => Get.to(() => const PrivacyPolicyView())),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: MyListTile(
                    icon: Icons.logout_outlined,
                    text: 'LOGOUT',
                    onTap: () async {
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance.signOut();
                      Get.offAll(() => LoginPage());
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}
