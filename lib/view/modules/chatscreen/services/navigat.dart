import 'package:flutter/material.dart';

Future removeNavigate(BuildContext context, Widget child) =>
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => child,
        ),
        (route) => false);

Future navigate(BuildContext context, Widget child) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => child,
    ));
