import 'dart:developer';
import 'package:d_art/view/modules/loginpage/screen/loginpage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:d_art/controller/controller/auth_service.dart';
// import 'package:d_art/view/widgets/Loginpage/loginpage.dart';

class SignupController extends GetxController {
  final AuthService _auth = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void gotoLogin() {
    Get.offAll(() => LoginPage());
  }

  Future<void> signup() async {
    if (formKey.currentState!.validate()) {
      try {
        final user = await _auth.createUserWithEmailAndPass(
            emailController.text, passwordController.text);
        if (user != null) {
          Get.snackbar('Success', 'Successfully signed up!');
          gotoLogin();
          log('User created successfully');
        }
      } catch (e) {
        Get.snackbar('Error', 'Failed to sign up: $e');
        log('Error during signup: $e');
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final user = await _auth.signInWithGoogle();
      if (user != null) {
        Get.snackbar('Success', 'Successfully signed in with Google!');
        gotoLogin();
        log('User signed in with Google successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in with Google: $e');
      log('Error during Google sign in: $e');
    }
  }
}
