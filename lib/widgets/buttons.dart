//this method will return a button with centered text

import 'package:flutter/material.dart';

general_button(
    {required onpressed,
    required String text,
    Color? backgroundColor,
    Color? textColor,
    double? width}) {
  backgroundColor ??= Colors.white;
  textColor ??= Colors.black;

  return Container(
    width: width ?? 300,
    height: 50,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 2,
          offset: const Offset(3, 3), // changes position of shadow
        ),
      ],
    ),
    child: TextButton(
      onPressed: onpressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 20,
        ),
      ),
    ),
  );
}

general_button_withoutshasow(
    {required onpressed,
    required String text,
    Color? backgroundColor,
    Color? textColor,
    bool underline = false}) {
  backgroundColor ??= Colors.transparent;
  textColor ??= Colors.black;

  return SizedBox(
    width: 300,
    height: 50,
    child: TextButton(
      onPressed: onpressed,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 20,
          decoration:
              underline ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    ),
  );
}
