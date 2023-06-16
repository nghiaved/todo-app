import 'package:client/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({super.key, required this.func, required this.text});

  final Function() func;
  final String text;

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: widget.func,
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            widget.text,
            style: const TextStyle(color: AppColors.whiteColor, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
