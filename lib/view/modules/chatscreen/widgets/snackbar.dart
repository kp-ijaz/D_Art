import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
    {required BuildContext context,
    required String message,
    Color? backgroundColor}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor:
          backgroundColor ?? const Color.fromARGB(255, 19, 102, 255),
      content: Text(message),
    ),
  );
}
