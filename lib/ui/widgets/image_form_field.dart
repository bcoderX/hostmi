import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hostmi/utils/app_color.dart';

class ImageFormField extends StatelessWidget {
  const ImageFormField({Key? key, this.label, this.onTap, this.fileImage})
      : super(key: key);
  final String? label;
  final void Function()? onTap;
  final File? fileImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label!),
        const SizedBox(height: 10),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: fileImage == null
                      ? const AssetImage("assets/images/image_not_found.png")
                      : FileImage(fileImage!) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: AppColor.grey,
                size: 45,
              ),
            ),
          ),
        )
      ],
    );
  }
}
