// import 'package:d_art/view/Homeowner/service_home.dart';
import 'package:d_art/view/drawer/widgets.dart';
import 'package:d_art/view/widgets/Loginpage/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey,
      child: Column(
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
                  icon: Icons.home, text: 'HOME', onTap: () => Get.back()),
              MyListTile(
                  icon: Icons.app_settings_alt_rounded,
                  text: 'REGISTER AS SERVICE PROVIDER',
                  onTap: () => Get.back()),
              MyListTile(
                  icon: Icons.privacy_tip,
                  text: 'Privacy & policy',
                  onTap: () => Get.back()),
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
      ),
    );
  }
}
