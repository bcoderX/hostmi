import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hostmi/api/providers/locale_provider.dart';
import 'package:hostmi/core/utils/color_constant.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/theme/app_style.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_property_address.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_property_pictures/widgets/local_image_preview.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/ui/widgets/labeled_field.dart';
import 'package:hostmi/ui/widgets/landloard_action_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_radio_button.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPropertyPictures extends StatefulWidget {
  const AddPropertyPictures({super.key});

  @override
  State<AddPropertyPictures> createState() => _AddPropertyPicturesState();
}

class _AddPropertyPicturesState extends State<AddPropertyPictures> {
  String? radioTypeGroup = "simple";
  String? radioCategoryGroup = "unique_house";
  final SizedBox _spacer = const SizedBox(height: 25);
  List<File?> images = [];
  List<File?> croppedImages = [];
  int size = 0;
  int loaded = 0;
  bool isLoaading = false;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColor.grey,
            statusBarIconBrightness: Brightness.dark),
        title: Text(AppLocalizations.of(context)!.addHouse),
        actions: const [TextButton(onPressed: null, child: Text("Sauter"))],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: getPadding(top: 7, bottom: 5),
                          child: Text("Photos (${croppedImages.length})",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeSemiBold14Gray900)),
                      CustomButton(
                          height: getVerticalSize(33),
                          width: getHorizontalSize(76),
                          text: "04 / 04",
                          fontStyle:
                              ButtonFontStyle.ManropeSemiBold14WhiteA700_1)
                    ]),
                Padding(
                    padding: getPadding(top: 16),
                    child: Container(
                        height: getVerticalSize(6),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: ColorConstant.blueGray50,
                            borderRadius:
                                BorderRadius.circular(getHorizontalSize(3))),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(getHorizontalSize(3)),
                            child: LinearProgressIndicator(
                                value: 1.0,
                                backgroundColor: ColorConstant.blueGray50,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    ColorConstant.brown500))))),
                _spacer,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Ajouter plus de photos (facultatif)",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColor.listItemGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Sélectionnez au maximum 10 photos.",
                        style: TextStyle(
                          color: AppColor.listItemGrey,
                        ),
                      ),
                    ),
                    _spacer,
                    SizedBox(
                      height: 350,
                      width: double.maxFinite,
                      child: isLoaading
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: getPadding(top: 16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text("Chargement des images..."),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        height: getVerticalSize(100),
                                        width: getHorizontalSize(100),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                getHorizontalSize(3))),
                                        child: Stack(
                                          children: [
                                            CircularProgressIndicator(
                                              value: loaded / size,
                                              backgroundColor:
                                                  ColorConstant.blueGray50,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      ColorConstant.brown500),
                                            ),
                                            Positioned.fill(
                                                child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "$loaded/$size",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : size == 0
                              ? Column(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        pickImage(-1);
                                      },
                                      child: const Center(
                                          child: Row(
                                        children: [
                                          Icon(Icons.camera_alt),
                                          Text("Choisir des fichiers"),
                                        ],
                                      )),
                                    ),
                                  ],
                                )
                              : PageView.builder(
                                  itemCount: croppedImages.length,
                                  controller: _pageController,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return LocalImagePreview(
                                      index: index,
                                      onAddNewImage:
                                          index == croppedImages.length - 1 &&
                                                  croppedImages.length < 10
                                              ? () {
                                                  setState(() {
                                                    images.add(null);
                                                    croppedImages.add(null);
                                                  });
                                                  _pageController.animateToPage(
                                                    index + 1,
                                                    duration: const Duration(
                                                      microseconds: 500,
                                                    ),
                                                    curve: Curves.easeOut,
                                                  );
                                                }
                                              : null,
                                      image: croppedImages[index],
                                      onPickImage: () {
                                        pickImage(index);
                                      },
                                      onEditImage: () {
                                        editImage(context, index);
                                      },
                                      onDeleteImage: () {
                                        setState(
                                          () {
                                            images[index] = null;
                                            croppedImages[index] = null;
                                          },
                                        );
                                      },
                                      onBackClick: index == 0
                                          ? null
                                          : () {
                                              _pageController.animateToPage(
                                                index - 1,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.easeOut,
                                              );
                                            },
                                      onRightClick:
                                          index == croppedImages.length - 1
                                              ? null
                                              : () {
                                                  _pageController.animateToPage(
                                                    index + 1,
                                                    duration: const Duration(
                                                      milliseconds: 500,
                                                    ),
                                                    curve: Curves.easeOut,
                                                  );
                                                },
                                      canAdd:
                                          index == croppedImages.length - 1 &&
                                              croppedImages.length < 10,
                                    );
                                  },
                                  //   Column
                                ),
                    ),
                    _spacer,
                    croppedImages.isEmpty
                        ? const SizedBox()
                        : const DefaultAppButton(
                            text: "Enregistrer",
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    DefaultAppButton(
                      text: "Sauter",
                      color: Colors.grey[200],
                      textColor: AppColor.black,
                      onPressed: () {
                        // onTapNext(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _picturesErrorDialog({required String title, required String content}) {
    showErrorDialog(
      title: title,
      content: content,
      context: context,
    );
  }

  Future pickImage(int index) async {
    if (index < 0) {
      try {
        final selectedImages = await ImagePicker().pickMultiImage();
        if (selectedImages.isEmpty) return;
        List<File?> files = [];
        int i = 0;
        setState(() {
          size = selectedImages.length <= 10 ? selectedImages.length : 10;
          isLoaading = true;
        });
        for (var file in selectedImages) {
          if (i < 10) {
            setState(() {
              loaded = i++;
            });
            final imageTemp = await compressFile(File(file.path));

            files.add(imageTemp);
          }
        }

        setState(() {
          isLoaading = false;
          images = [...files];
          croppedImages = [...files];
        });
      } on PlatformException {}
    } else {
      try {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image == null) return;

        final imageTemp = await compressFile(File(image.path));
        setState(() {
          images[index] = imageTemp;
          croppedImages[index] = imageTemp;
        });
      } on PlatformException {}
    }
  }

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;

    final lastIndex = filePath.lastIndexOf('.');
    final splitted = filePath.substring(0, (lastIndex));
    final outPath = "${splitted}_out.png";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      format: CompressFormat.png,
      quality: 50,
    );

    return File(result!.path);
  }

  Future<void> editImage(BuildContext context, int index) async {
    if (images[index] != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: images[index]!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Modifier l'image",
            toolbarColor: AppColor.grey,
            toolbarWidgetColor: AppColor.black,
            activeControlsWidgetColor: AppColor.primary,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            backgroundColor: AppColor.grey,
            dimmedLayerColor: AppColor.grey.withOpacity(.5),
          ),
          IOSUiSettings(
            title: "Modifier l'image",
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          croppedImages[index] = File(croppedFile.path);
        });
      }
    }
  }
}
