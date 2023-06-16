import 'package:client/constants/app_colors.dart';
import 'package:client/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Widget picPicker(
  bool isFileSelected,
  String fileName,
  Function onFilePicked,
) {
  Future<XFile?> imageFile;
  ImagePicker picker = ImagePicker();

  return Column(
    children: [
      ImageWidget(image: fileName),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 35,
            width: 35,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                Icons.image,
                size: 35,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                imageFile = picker.pickImage(source: ImageSource.gallery);
                imageFile.then((file) async {
                  onFilePicked(file);
                });
              },
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            height: 35,
            width: 35,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(
                Icons.camera,
                size: 35,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                imageFile = picker.pickImage(source: ImageSource.camera);
                imageFile.then((file) async {
                  onFilePicked(file);
                });
              },
            ),
          ),
        ],
      ),
    ],
  );
}
