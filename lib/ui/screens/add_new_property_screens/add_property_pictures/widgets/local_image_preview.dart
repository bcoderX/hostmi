import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/widgets/action_button.dart';
import 'package:hostmi/ui/widgets/rounded_text_field.dart';
import 'package:hostmi/utils/app_color.dart';

class LocalImagePreview extends StatelessWidget {
  const LocalImagePreview({
    super.key,
    this.image,
    this.onPickImage,
    this.onEditImage,
    this.onDeleteImage,
    required this.index,
    this.total,
    this.onBackClick,
    this.onRightClick,
    this.canAdd = false,
    this.onAddNewImage,
    this.onEditDescription,
    required this.textController,
  });
  final bool canAdd;
  final int index;
  final int? total;
  final File? image;
  final TextEditingController textController;
  final void Function()? onPickImage;
  final void Function()? onEditImage;
  final void Function()? onDeleteImage;
  final void Function()? onBackClick;
  final void Function()? onRightClick;
  final void Function()? onAddNewImage;
  final void Function(String value)? onEditDescription;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Photo ${index + 1}",
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 18,
                color: AppColor.listItemGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
            canAdd
                ? InkWell(
                    onTap: onAddNewImage,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle,
                          color: AppColor.primary,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Ajouter")
                      ],
                    ),
                  )
                : const SizedBox()
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap: onPickImage,
                    child: Container(
                      width: double.infinity,
                      height: getVerticalSize(200),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: image == null
                                ? const AssetImage(
                                    "assets/images/image_not_found.png")
                                : FileImage(image!) as ImageProvider,
                            fit: BoxFit.fitHeight,
                          ),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[200]!),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: const Icon(
                        Icons.camera_alt,
                        color: AppColor.grey,
                        size: 45,
                      ),
                    ),
                  ),
                  Positioned.fill(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: onBackClick,
                          icon: const Icon(
                            Icons.arrow_circle_left,
                            size: 30,
                          )),
                      IconButton(
                        onPressed: onRightClick,
                        icon: const Icon(
                          Icons.arrow_circle_right,
                          size: 30,
                        ),
                      ),
                    ],
                  ))
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ActionButton(
                      padding: getPadding(top: 5, bottom: 5, left: 7, right: 7),
                      icon: const Icon(Icons.camera_alt),
                      text: "Choisis une ${image == null ? '' : 'autre '}photo",
                      onPressed: onPickImage,
                    ),
                    ActionButton(
                      padding: getPadding(top: 5, bottom: 5, left: 7, right: 7),
                      icon: const Icon(Icons.edit),
                      text: "Modifier",
                      onPressed: onEditImage,
                    ),
                    ActionButton(
                      padding: getPadding(top: 5, bottom: 5, left: 7, right: 7),
                      icon: const Icon(Icons.delete),
                      text: "Suprimer",
                      onPressed: onDeleteImage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        const SizedBox(
          width: double.infinity,
          child: Text(
            "Décrire l'image",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 18,
              color: AppColor.listItemGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        RoundedTextField(
          onChanged: onEditDescription,
          controller: textController,
          errorText: "Une erreur s'est produite",
          placeholder: "Ajouter un titre ou une description",
          maxLines: 2,
        ),
      ],
    );
  }
}
