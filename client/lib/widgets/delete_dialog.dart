import 'package:client/constants/app_colors.dart';
import 'package:flutter/material.dart';

Future<void> showDeleteDialog(BuildContext context, Function() delete) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Toto?'),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: AppColors.redColor,
              child: InkWell(
                onTap: delete,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text(
                    'Yes',
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                ),
              ),
            ),
            Container(
              color: AppColors.greenColor,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text(
                    'No',
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
