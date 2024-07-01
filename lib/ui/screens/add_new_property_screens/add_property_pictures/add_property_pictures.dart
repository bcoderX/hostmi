import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/core/utils/color_constant.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/theme/app_style.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_property_pictures/widgets/local_image_preview.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/preview_and_save.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/widgets/custom_button.dart';
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
  List<String> descriptions = [];
  List<TextEditingController> descriptionControllers = [];
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
          title: Text(AppLocalizations.of(context)!.addHouse),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        context.read<HostmiProvider>().houseForm.images =
                            croppedImages;
                        context
                            .read<HostmiProvider>()
                            .houseForm
                            .imagesDescriptions = descriptions;
                        return const PreviewAndSave();
                      },
                    ),
                  );
                },
                child: const Text("Sauter"))
          ],
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                              borderRadius: BorderRadius.circular(
                                  getHorizontalSize(10.0))),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  getHorizontalSize(10.0)),
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
                      isLoaading
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
                              : LayoutBuilder(builder: (context, constraints) {
                                  return ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxHeight: 800),
                                    child: PageView.builder(
                                      itemCount: croppedImages.length,
                                      controller: _pageController,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return LocalImagePreview(
                                          textController:
                                              descriptionControllers[index],
                                          index: index,
                                          onEditDescription: (String value) {
                                            descriptions[index] = value;
                                          },
                                          onAddNewImage: index ==
                                                      croppedImages.length -
                                                          1 &&
                                                  croppedImages.length < 10
                                              ? () {
                                                  setState(() {
                                                    images.add(null);
                                                    croppedImages.add(null);
                                                    descriptions.add("");
                                                    descriptionControllers.add(
                                                        TextEditingController());
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
                                          onRightClick: index ==
                                                  croppedImages.length - 1
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
                                          canAdd: index ==
                                                  croppedImages.length - 1 &&
                                              croppedImages.length < 10,
                                        );
                                      },
                                      //   Column
                                    ),
                                  );
                                }),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DefaultAppButton(
            text: croppedImages.isEmpty
                ? "Sauter"
                : "Prévusialiser et enregistrer",
            color: croppedImages.isEmpty ? Colors.grey[200] : null,
            textColor: croppedImages.isEmpty ? AppColor.black : null,
            onPressed: () {
              context.read<HostmiProvider>().houseForm.images = croppedImages;
              context.read<HostmiProvider>().houseForm.imagesDescriptions =
                  descriptions;

              context.push('/add-house-preview');
            },
          ),
        )
        // : Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: DefaultAppButton(
        //       onPressed: () {
        //         context.read<HostmiProvider>().houseForm.images =
        //             croppedImages;
        //         context.read<HostmiProvider>().houseForm.imagesDescriptions =
        //             descriptions;

        //         context.push('/add-house-preview');
        //       },
        //       text: "Prévusialiser et enregistrer",
        //     ),
        //   ),
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
          descriptions = List.generate(images.length, (index) => "");
          descriptionControllers =
              List.generate(images.length, (index) => TextEditingController());
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
    final outPath = "${splitted}_out.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      format: CompressFormat.jpeg,
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
