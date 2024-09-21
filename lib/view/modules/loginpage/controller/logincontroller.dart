import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/controller/controller/auth_service.dart';
import 'package:d_art/view/modules/bottomnavbar/screen/bottomnav_bar.dart';
import 'package:d_art/view/modules/langingpages/screen/messagescreen/messagepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isServiceProvider = false.obs;

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
      isServiceProvider.value = profileData['isServiceProvider'] == true;
      if (profileData['profileCompleted'] == true) {
        Get.offAll(() => BottomNavBar());
      } else {
        Get.offAll(() => const MessagePage());
      }
    } else {
      Get.offAll(() => const MessagePage());
    }
  }

  Future<void> signOutWithGoogle() async {
    try {
      await _auth.signOut();
      Get.offAll(() => const MessagePage());
    } catch (e) {
      log(e.toString());
    }
  }
}
