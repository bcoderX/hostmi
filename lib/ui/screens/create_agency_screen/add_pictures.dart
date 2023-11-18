import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/screens/gears_loading_page.dart';
import 'package:hostmi/ui/screens/image_editor/image_editor.dart';
import 'package:hostmi/ui/screens/agency_screen/agency_screen.dart';
import 'package:hostmi/ui/screens/success_screen.dart';
import 'package:hostmi/ui/widgets/labeled_field.dart';
import 'package:hostmi/ui/widgets/landloard_action_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/image_form_field.dart';

class AddAgencyPictures extends StatefulWidget {
  const AddAgencyPictures({Key? key}) : super(key: key);

  @override
  State<AddAgencyPictures> createState() => _AddAgencyPicturesState();
}

class _AddAgencyPicturesState extends State<AddAgencyPictures> {
  List<File?> images = [null, null];
  List<File?> croppedImages = [null, null];
  final editorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor.grey,
          foregroundColor: AppColor.black,
          elevation: 0.0,
          // systemOverlayStyle: const SystemUiOverlayStyle(
          //   statusBarIconBrightness: Brightness.dark,
          // ),
          automaticallyImplyLeading: false,
          title: const Text(
            "Ajouter les images de l'agence",
            style: TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  context.go(keyPublishRoute);
                },
                child: const Text("Sauter")),
          ]),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Photos de couverture (Facultatif)",
                            textAlign: TextAlign.start,
                            style:
                                TextStyle(fontSize: 18, color: Colors.black87),
                          ),
                        ),
                        const SizedBox(
                            width: double.infinity,
                            child: Text(
                                "La photo de couverture est la vitrine de votre agence. ")),
                        const SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          onTap: () async {
                            pickImage(0);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: croppedImages[0] == null
                                    ? const AssetImage(
                                        "assets/images/image_not_found.png")
                                    : FileImage(croppedImages[0]!)
                                        as ImageProvider,
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ActionButton(
                                icon: const Icon(Icons.camera_alt),
                                text: "Choisis une photo",
                                onPressed: () async {
                                  await pickImage(0);
                                },
                              ),
                              ActionButton(
                                icon: const Icon(Icons.edit),
                                text: "Modifier",
                                onPressed: () async {
                                  await _cropImage(context, 0);
                                },
                              ),
                              const ActionButton(
                                  icon: Icon(Icons.delete), text: "Suprimer"),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Material(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(5.0),
                          child: MaterialButton(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              minWidth: double.infinity,
                              onPressed: () {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (BuildContext context) {
                                //       return GearsLoadingPage(
                                //         page: const SuccessPage(
                                //           continueToPage: LandlordPage(),
                                //         ),
                                //         operationTitle:
                                //             AppLocalizations.of(context)!.creatingPage,
                                //       );
                                //     },
                                //   ),
                                // );
                              },
                              child: const Text(
                                "Enregistrer",
                                style: TextStyle(
                                  color: AppColor.grey,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Photo de profile (Facultatif)",
                            textAlign: TextAlign.start,
                            style:
                                TextStyle(fontSize: 18, color: Colors.black87),
                          ),
                        ),
                        const SizedBox(
                            width: double.infinity,
                            child: Text(
                                "La photo de profile permet de reconnaitre votre agence parmi les autres")),
                        const SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          onTap: () async {
                            await pickImage(1);
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                image: croppedImages[1] == null
                                    ? const AssetImage(
                                        "assets/images/image_not_found.png")
                                    : FileImage(croppedImages[1]!)
                                        as ImageProvider,
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
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ActionButton(
                                icon: const Icon(Icons.camera_alt),
                                text: "Choisis une photo",
                                onPressed: () async {
                                  await pickImage(1);
                                },
                              ),
                              ActionButton(
                                icon: const Icon(Icons.edit),
                                text: "Modifier",
                                onPressed: () async {
                                  await _cropImage(context, 1);
                                },
                              ),
                              ActionButton(
                                icon: const Icon(Icons.delete),
                                text: "Suprimer",
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Material(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(5.0),
                          child: MaterialButton(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              minWidth: double.infinity,
                              onPressed: () {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (BuildContext context) {
                                //       return GearsLoadingPage(
                                //         page: const SuccessPage(
                                //           continueToPage: LandlordPage(),
                                //         ),
                                //         operationTitle:
                                //             AppLocalizations.of(context)!.creatingPage,
                                //       );
                                //     },
                                //   ),
                                // );
                              },
                              child: const Text(
                                "Enregistrer",
                                style: TextStyle(
                                  color: AppColor.grey,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Material(
                  color: Colors.grey.withOpacity(.7),
                  borderRadius: BorderRadius.circular(5.0),
                  child: MaterialButton(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      minWidth: double.infinity,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const ImageEditor();
                            },
                          ),
                        );

                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (BuildContext context) {
                        //       return GearsLoadingPage(
                        //         page: const SuccessPage(
                        //           continueToPage: LandlordPage(),
                        //         ),
                        //         operationTitle:
                        //             AppLocalizations.of(context)!.creatingPage,
                        //       );
                        //     },
                        //   ),
                        // );
                      },
                      child: const Text(
                        "Terminer",
                        style: TextStyle(
                          color: AppColor.primary,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickImage(int index) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = await compressFile(File(image.path));
      setState(() {
        images[index] = imageTemp;
        croppedImages[index] = imageTemp;
      });
    } on PlatformException {}
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

  Future<void> _cropImage(BuildContext context, int index) async {
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
