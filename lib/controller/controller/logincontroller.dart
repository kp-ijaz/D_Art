import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/controller/controller/auth_service.dart';
import 'package:d_art/view/bottomnav/bottomnav_bar.dart';
import 'package:d_art/view/widgets/AfterLoginPage/messagepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      final userDetails = await _auth.getUserDetails();
      if (userDetails['email'] == null || userDetails['password'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User not signed up. Please sign up first.'),
        ));
        setLoading(false);
        return;
      }
      if (userDetails['email'] != email) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Enter correct email or you don\'t have a valid email.'),
        ));
        setLoading(false);
        return;
      }
      if (userDetails['password'] != password) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Enter valid password.'),
        ));
        setLoading(false);
        return;
      }
      final user = await _auth.loginUserWithEmailAndPass(
          userDetails['email']!, userDetails['password']!);
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
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        await _saveEmailToFirestore(
            userCredential.user!.uid, userCredential.user!.email!);

        await navigateBasedOnEmail(userCredential.user!.email, context);

        log('Google sign-in successful');
        log('$userCredential.user?.displayName');
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

  Future<void> _saveEmailToFirestore(String uid, String email) async {
    try {
      await FirebaseFirestore.instance.collection('profiles').doc(uid).set({
        'email': email,
      }, SetOptions(merge: true));
    } catch (e) {
      log('Error saving email to Firestore: $e');
      throw e;
    }
  }
}
