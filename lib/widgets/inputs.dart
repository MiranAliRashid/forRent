import 'package:flutter/material.dart';

//make a general input field
generalInput({
  String? hintText,
  String? labelText,
  TextEditingController? controller,
  TextInputType? textInputType,
  bool? obscureText,
  FormFieldValidator? validator,
}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    obscureText: obscureText ?? false,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      hintText: hintText,
      labelText: labelText,
    ),
  );
}
