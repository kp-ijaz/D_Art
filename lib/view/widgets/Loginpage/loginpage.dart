import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/controller/controller/auth_service.dart';
import 'package:d_art/controller/controller/logincontroller.dart';
import 'package:d_art/view/bottomnav/bottomnav_bar.dart';
import 'package:d_art/view/widgets/AfterLoginPage/messagepage.dart';
import 'package:d_art/view/widgets/Signuppage/signuppage.dart';
import 'package:d_art/view/widgets/commonwidgets/textformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:sign_in_button/sign_in_button.dart';

class Loginpage extends StatelessWidget {
  Loginpage({super.key});

  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Lottie.asset('assets/login.json',
                        width: 2000, height: 260),
                  ),
                ),
                const Text(
                  'Log in',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                customformfield(
                  textinput: 'E-mail',
                  controller: _email,
                  textinputType: TextInputType.emailAddress,
                  obscure: false,
                  validator: (value) {
                    const pattern =
                        r'^[a-zA-Z0-9.%+-]+@[a-zA-Z0-9.-]+.[a-zA-Z]{2,}$';
                    final regex = RegExp(pattern);
                    return value == null ||
                            value.isEmpty ||
                            !regex.hasMatch(value)
                        ? 'Enter a valid email address'
                        : null;
                  },
                ),
                customformfield(
                  textinput: 'Password',
                  controller: _password,
                  textinputType: TextInputType.text,
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text('Forgot password?'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.offAll(() => SignupPage());
                            },
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: const ButtonStyle(),
                            onPressed: () => _login(context),
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    'Or',
                    style: TextStyle(fontSize: 19),
                  ),
                ),
                Obx(() {
                  if (loginController.isLoading.value) {
                    return const CircularProgressIndicator();
                  } else {
                    return SignInButton(
                      Buttons.google,
                      onPressed: () => signInWithGoogle(context),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  gotoHome(BuildContext context) => Get.offAll(() => BottomNavBar());

  gotoMessagePage(BuildContext context) =>
      Get.offAll(() => const MessagePage());

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final userDetails = await _auth.getUserDetails();
      if (userDetails['email'] == null || userDetails['password'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User not signed up. Please sign up first.'),
        ));
        return;
      }
      if (userDetails['email'] != _email.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Enter correct email or you don\'t have a valid email.'),
        ));
        return;
      }
      if (userDetails['password'] != _password.text) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Enter valid password.'),
        ));
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
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    loginController.setLoading(true);

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

        // Save email to Firestore
        await _saveEmailToFirestore(
            userCredential.user!.uid, userCredential.user!.email!);

        // Navigate based on email
        await navigateBasedOnEmail(userCredential.user!.email, context);

        log('Google sign-in successful');
        print(userCredential.user?.displayName);
      } else {
        log('Google sign-in failed.');
      }
    } catch (e) {
      log('ERROR ON AUTH LOGIN >> : $e');
    } finally {
      loginController.setLoading(false);
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
      }, SetOptions(merge: true)); // Use merge option to update existing fields
    } catch (e) {
      log('Error saving email to Firestore: $e');
      throw e; // Rethrow the error to handle it elsewhere if needed
    }
  }
}
