import 'package:flutter/material.dart';

Widget customformfield(
    {required String textinput,
    required TextEditingController controller,
    required TextInputType textinputType,
    required bool obscure,
    required String? Function(dynamic value) validator}) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
    child: TextFormField(
      keyboardType: textinputType,
      obscureText: obscure,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(17))),
          labelText: (textinput),
          filled: true,
          fillColor: const Color.fromARGB(255, 214, 212, 205)),
      controller: controller,
      validator: validator,
    ),
  );
}
