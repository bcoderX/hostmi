import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/houses/add_picture.dart';
import 'package:hostmi/api/supabase/houses/insert_house.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/core/utils/color_constant.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_property_basic_details.dart';
import 'package:hostmi/ui/screens/agency_screen/agency_screen.dart';
import 'package:hostmi/ui/screens/publisher_screen.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/ui/widgets/house_Preview_card.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PreviewAndSave extends StatefulWidget {
  const PreviewAndSave({super.key});

  @override
  State<PreviewAndSave> createState() => _PreviewAndSaveState();
}

class _PreviewAndSaveState extends State<PreviewAndSave> {
  final SizedBox _spacer = const SizedBox(height: 25);
  bool _isSaving = false;
  bool _isSaved = false;
  int _step = 2;
  int _imagesSize = 0;
  int _currentImage = 1;
  String houseId = "";
  bool _errorSavingFile = false;
  String _stateText = "Nous enregistrons \nvotre propriété...";
  File? mainImage;
  late List<File?> images;
  late List<String> imagesDescriptions;
  @override
  void initState() {
    images = [];
    imagesDescriptions = [];
    final rawImages = [...?context.read<HostmiProvider>().houseForm.images];
    final rawImagesDescription = [
      ...?context.read<HostmiProvider>().houseForm.imagesDescriptions
    ];
    for (int i = 0; i < rawImages.length; i++) {
      if (rawImages[i] != null) {
        images.add(rawImages[i]);
        imagesDescriptions.add(rawImagesDescription[i]);
      }
    }
    if (context.read<HostmiProvider>().houseForm.mainImage != null) {
      mainImage = context.read<HostmiProvider>().houseForm.mainImage;
      images.insert(0, mainImage);
      imagesDescriptions.insert(0, "");
    }
    _imagesSize = images.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isSaved
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.greenAccent[200],
                size: getSize(100),
              ),
              const Text(
                "Enregistrement terminé",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 185),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        context.read<HostmiProvider>().reSetHouseForm();
                        return const AddNewPropertyBasicDetails();
                      },
                    ));
                  },
                  child: const Text("Ajouter une autre maison"),
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 185),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColor.black,
                    backgroundColor: Colors.grey[200],
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return const PublisherPage();
                      },
                    ));
                  },
                  child: const Text("Terminer"),
                ),
              ),
            ],
          )
        : _isSaving
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _errorSavingFile
                      ? Icon(
                          Icons.error,
                          color: AppColor.primary,
                          size: getSize(50),
                        )
                      : LoadingAnimationWidget.threeArchedCircle(
                          color: AppColor.primary,
                          size: getSize(50),
                        ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    _stateText,
                    textAlign: TextAlign.center,
                  ),
                  _step == 2
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$_currentImage/$_imagesSize",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            _errorSavingFile
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          uploadFiles(start: _currentImage - 1);
                                        },
                                        child: const Text("Réessayer"),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: AppColor.black,
                                          backgroundColor: Colors.grey[200],
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return const PublisherPage();
                                            },
                                          ));
                                        },
                                        child: const Text("Terminer"),
                                      ),
                                    ],
                                  )
                                : const SizedBox()
                          ],
                        )
                      : const SizedBox()
                ],
              )
            : Scaffold(
                backgroundColor: ColorConstant.gray50,
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  backgroundColor: AppColor.grey,
                  foregroundColor: AppColor.black,
                  elevation: 0.0,
                  systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: AppColor.grey,
                      statusBarIconBrightness: Brightness.dark),
                  title: const Text("Prévisualiser et enregistrer"),
                  actions: const [
                    IconButton(onPressed: null, icon: Icon(Icons.save))
                  ],
                ),
                body: Scrollbar(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        children: [
                          _spacer,
                          HousePreviewCard(
                              house: context.read<HostmiProvider>().houseForm),
                        ],
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: DefaultAppButton(
                    text: "Enregistrer maintenant",
                    onPressed: () async {
                      setState(() {
                        _stateText = "Nous enregistrons \nvotre propriété...";
                        _isSaving = true;
                      });
                      String? result = await insertHouse(
                          context.read<HostmiProvider>().houseForm);
                      if (result == null) {
                        setState(() {
                          _isSaving = false;
                        });

                        _houseSavingErrorDialog(
                          title: "Echec de l'enregistrement",
                          content:
                              "Nous rencontrons un problème lors de l'enregistrement de votre propriété. Veuillez éessayez.",
                        );
                      } else {
                        houseId = result;
                        uploadFiles(start: _currentImage - 1);
                      }
                    },
                  ),
                ),
              );
  }

  uploadFiles({int start = 0}) async {
    AgencyModel? agency = await getAgencyDetails();
    if (agency != null) {
      setState(() {
        _errorSavingFile = false;
        _stateText = "Nous enregistrons \nles images de votre propriété...";
        _step = 2;
      });
      for (int i = start; i < images.length; i++) {
        setState(() {
          _currentImage = i + 1;
        });
        final result = await _upload(
          file: images[i],
          description: imagesDescriptions[i],
          userId: supabase.auth.currentUser!.id.toString(),
          agencyId: agency.id!,
          houseId: houseId,
          role: _currentImage == 1 && mainImage != null ? 1 : 2,
        );
        if (result == false) {
          setState(() {
            _errorSavingFile = true;
            _stateText = "Erreur d'enregistrement des images";
          });
          //Aborting image upload when saving fail
          return;
        }
      }
    }

    setState(() {
      _isSaved = true;
    });
  }

  Future<bool> _upload({
    required File? file,
    required String userId,
    required String agencyId,
    required String houseId,
    String description = "",
    int role = 2,
  }) async {
    // print(userId);
    try {
      final bytes = await file!.readAsBytes();
      final String fileName = file.path.split(Platform.pathSeparator).last;
      final filePath = "$agencyId/houses/$houseId/$userId/$fileName";
      final imageUrlResponse =
          await supabase.storage.from('agencies').uploadBinary(
                filePath,
                bytes,
              );

      final isAdded = await addHousePicture(
          houseId: houseId,
          imageUrl: imageUrlResponse,
          role: role,
          description: description);
      if (isAdded && role == 1) {
        updateHouseImage(houseId: houseId, imageUrl: filePath);
      }
      return isAdded;
      // widget.onUpload(imageUrlResponse);
    } on StorageException catch (error) {
      if (mounted) {
        _houseSavingErrorDialog(
            title: "Erreur d'enregistrement",
            content:
                "Une erreur s'est produite lors de l'enregistrement des images. Veuillez réessayer.");
        debugPrint(error.toString());
      }
    } catch (error) {
      if (mounted) {
        _houseSavingErrorDialog(
            title: "Erreur d'enregistrement",
            content:
                "Une erreur s'produite lors de l'enregistrement des images. Veuillez réessayer.");
        debugPrint(error.toString());
      }
    }
    return false;
  }

  _houseSavingErrorDialog({
    required String title,
    required String content,
  }) {
    showErrorDialog(title: title, content: content, context: context);
  }
}
