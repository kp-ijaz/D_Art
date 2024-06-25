import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/controller/controller/auth_service.dart';
import 'package:d_art/view/bottomnav/bottomnav_bar.dart';
import 'package:d_art/view/widgets/AfterLoginPage/messagepage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  final AuthService _auth = AuthService();

  void setLoading(bool value) {
    isLoading.value = value;
  }

  Future<void> login(BuildContext context, GlobalKey<FormState> formKey,
      String email, String password) async {
    if (formKey.currentState!.validate()) {
      setLoading(true);
      final user = await _auth.loginUserWithEmailAndPass(email, password);
      if (user != null) {
        await navigateBasedOnEmail(user.email, context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid email or password.'),
        ));
      }
      setLoading(false);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    setLoading(true);

    try {
      final user = await _auth.signInWithGoogle();
      if (user != null) {
        await navigateBasedOnEmail(user.email, context);
        log('Google sign-in successful');
        log('${user.displayName}');
      } else {
        log('Google sign-in failed.');
      }
    } catch (e) {
      log('ERROR ON AUTH LOGIN >> : $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> navigateBasedOnEmail(String? email, BuildContext context) async {
    if (email == null) return;
    final snapshot = await FirebaseFirestore.instance
        .collection('profiles')
        .where('email', isEqualTo: email)
        .get();
    if (snapshot.docs.isNotEmpty) {
      final profileData = snapshot.docs.first.data();
      if (profileData['profileCompleted'] == true) {
        Get.offAll(() => BottomNavBar());
      } else {
        Get.offAll(() => const MessagePage());
      }
    } else {
      Get.offAll(() => const MessagePage());
    }
  }
}
