import 'dart:io';
import 'package:flutter/material.dart';

class ImageWidget extends StatefulWidget {
  const ImageWidget({super.key, required this.image});

  final String image;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: widget.image.isNotEmpty
          ? Image.file(
              File(widget.image),
              height: 100,
              width: 100,
              fit: BoxFit.fill,
            )
          : SizedBox(
              child: Image.network(
                'https://hope.be/wp-content/uploads/2015/05/no-user-image.gif',
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
            ),
    );
  }
}
