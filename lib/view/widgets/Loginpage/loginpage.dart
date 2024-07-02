// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:d_art/controller/controller/auth_service.dart';
import 'package:d_art/controller/controller/logincontroller.dart';
// import 'package:d_art/view/bottomnav/bottomnav_bar.dart';
// import 'package:d_art/view/widgets/AfterLoginPage/messagepage.dart';
import 'package:d_art/view/widgets/Signuppage/signuppage.dart';
import 'package:d_art/view/widgets/commonwidgets/textformfield.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

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
                  'LOG IN',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                customformfield(
                  textinput: 'E-mail',
                  controller: _email,
                  textinputType: TextInputType.emailAddress,
                  obscure: false,
                  validator: (value) {
                    const pattern =
                        r'^[a-zA-Z0-9.%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
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
                  padding: const EdgeInsets.only(
                    left: 25,
                    right: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text('Forgot password?'),
                          ),
                          // TextButton(
                          //   onPressed: () {
                          //     Get.offAll(() => SignupPage());
                          //   },
                          //   child: const Text(
                          //     'Sign up',
                          //     style: TextStyle(
                          //       fontSize: 20,
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // ),
                          ElevatedButton(
                            style: const ButtonStyle(),
                            onPressed: () => loginController.login(
                              context,
                              _formKey,
                              _email.text,
                              _password.text,
                            ),
                            child: const Text(
                              'LOG IN',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.offAll(() => SignupPage());
                    },
                    child: const Text(
                      "Don't you have an account? Sign Up",
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
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
                      onPressed: () =>
                          loginController.signInWithGoogle(context),
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
}
