import 'package:d_art/controller/controller/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:d_art/view/widgets/commonwidgets/textformfield.dart';
// import 'package:d_art/controller/controller/auth_service.dart';
// import 'signup_controller.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final SignupController signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              SafeArea(
                child: Lottie.asset('assets/signup.json'),
              ),
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Form(
                key: signupController.formKey,
                child: Column(
                  children: [
                    customformfield(
                      textinput: 'E-mail',
                      controller: signupController.emailController,
                      textinputType: TextInputType.emailAddress,
                      obscure: false,
                      validator: (value) {
                        const pattern =
                            r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                            r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                            r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                            r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                            r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                            r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                            r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
                        final regex = RegExp(pattern);

                        return value!.isNotEmpty && !regex.hasMatch(value)
                            ? 'Enter a valid email address'
                            : null;
                      },
                    ),
                    customformfield(
                        textinput: 'Password',
                        controller: signupController.passwordController,
                        textinputType: TextInputType.text,
                        obscure: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        }),
                    customformfield(
                        textinput: 'Confirm Password',
                        controller: signupController.confirmPasswordController,
                        textinputType: TextInputType.text,
                        obscure: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value !=
                              signupController.passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            signupController.gotoLogin();
                          },
                          child: const Text(
                            'Log in',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          style: const ButtonStyle(),
                          onPressed: () => signupController.signup(),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        )
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
              SignInButton(
                Buttons.google,
                onPressed: () => signupController.signInWithGoogle(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
