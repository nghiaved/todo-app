import 'package:client/constants/app_colors.dart';
import 'package:flutter/material.dart';

InputDecoration textInputDecoration(text, IconData? icon) {
  return InputDecoration(
    labelText: text,
    labelStyle: const TextStyle(
      color: AppColors.blackColor,
      fontWeight: FontWeight.w300,
    ),
    prefixIcon: icon != null ? Icon(icon, color: AppColors.primaryColor) : null,
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
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
