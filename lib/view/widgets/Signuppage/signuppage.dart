import 'dart:developer';
import 'package:d_art/controller/controller/auth_service.dart';
import 'package:d_art/view/widgets/Loginpage/loginpage.dart';
import 'package:d_art/view/widgets/commonwidgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sign_in_button/sign_in_button.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final _auth = AuthService();

  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _confirmpass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: [
              SafeArea(
                child: Lottie.asset(
                  'assets/signup.json',
                ),
              ),
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    customformfield(
                      textinput: 'E-mail',
                      controller: _email,
                      textinputType: TextInputType.emailAddress,
                      obscure: false,
                      validator: (value) {
                        const pattern =
                            // r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
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
                        controller: _pass,
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
                        controller: _confirmpass,
                        textinputType: TextInputType.text,
                        obscure: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != _pass.text) {
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
                              Get.offAll(() => Loginpage());
                            },
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )),
                        ElevatedButton(
                            style: const ButtonStyle(),
                            onPressed: () => _signup(context),
                            child: const Text(
                              'Sign up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ))
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
                onPressed: () => _signInWithGoogle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  gotoLogin(BuildContext context) {
    Get.offAll(() => Loginpage());
  }

  _signup(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final user =
            await _auth.createUserWithEmailAndPass(_email.text, _pass.text);
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Successfully signed up!'),
          ));
          gotoLogin(context);
          log('User created successfully');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to sign up: $e'),
        ));
        log('Error during signup: $e');
      }
    }
  }

  _signInWithGoogle(BuildContext context) async {
    try {
      final user = await _auth.signInWithGoogle();
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Successfully signed in with Google!'),
        ));
        gotoLogin(context);
        log('User signed in with Google successfully');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to sign in with Google: $e'),
      ));
      log('Error during Google sign in: $e');
    }
  }
}
