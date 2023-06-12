import 'package:flutter/material.dart';

InputDecoration textInputDecoration(text, icon) {
  return InputDecoration(
    labelText: text,
    labelStyle:
        const TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
    prefixIcon: Icon(
      icon,
      color: const Color(0xffee7b64),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffee7b64), width: 2),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffee7b64), width: 2),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffee7b64), width: 2),
    ),
  );
}

void nextScreen(context, page) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(fontSize: 14)),
      backgroundColor: color,
      duration: const Duration(seconds: 2),
    ),
  );
}
