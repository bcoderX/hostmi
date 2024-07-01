import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/rest/houses/add_picture.dart';
import 'package:hostmi/api/supabase/rest/houses/insert_house.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/ui/widgets/house_preview_card.dart';
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
        ? WillPopScope(
            onWillPop: () async {
              context.go(keyPublishRoute);
              return false;
            },
            child: Scaffold(
              body: SizedBox(
                width: double.infinity,
                child: Column(
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
                        style: ElevatedButton.styleFrom(
                          foregroundColor: AppColor.black,
                          backgroundColor: AppColor.grey,
                        ),
                        onPressed: () {
                          context.go(keyPublishRoute);
                        },
                        child: const Text("Terminer"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : _isSaving
            ? Scaffold(
                body: SizedBox(
                  width: double.infinity,
                  child: Column(
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
                                              uploadFiles(
                                                  start: _currentImage - 1);
                                            },
                                            child: const Text("Réessayer"),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: AppColor.black,
                                              backgroundColor: AppColor.grey,
                                            ),
                                            onPressed: () {
                                              context.go(keyPublishRoute);
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
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: ColorConstant.gray50,
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  backgroundColor: AppColor.grey,
                  foregroundColor: AppColor.black,
                  elevation: 0.0,
                  title: const Text("Prévisualiser et enregistrer"),
                  actions: [
                    IconButton(
                        onPressed: _onSave,
                        color: AppColor.primary,
                        icon: const Icon(Icons.save))
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
                    onPressed: _onSave,
                  ),
                ),
              );
  }

  uploadFiles({int start = 0}) async {
    List<AgencyModel?> agencyList = await getAgencyDetails();
    AgencyModel? agency = agencyList[0];
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

  Future<void> _onSave() async {
    setState(() {
      _stateText = "Nous enregistrons \nvotre propriété...";
      _isSaving = true;
    });
    String searchTerms = generateSearchTerms();

    String? result = await insertHouse(context.read<HostmiProvider>().houseForm,
        searchTerms: searchTerms);
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

  String generateSearchTerms() {
    String terms = "";
    HouseModel houseForm = context.read<HostmiProvider>().houseForm;
    //Add houses types
    terms = "$terms ${houseForm.houseType!.fr}, ";

    //Add houses categories
    terms = "$terms ${houseForm.houseCategory!.fr}, ";

    //Add houses gender
    terms = "$terms ${houseForm.gender!.fr}, ";

    //Add houses countries
    terms = "$terms ${houseForm.country!.fr}, ";

    //Add houses city
    terms = "$terms ${houseForm.city}, ";

    //Add houses sector
    terms = "Secteur $terms ${houseForm.sector}, ";

    //Add houses quarter
    terms = "$terms ${houseForm.quarter}, ";

    //Add houses full address
    terms = "$terms ${houseForm.fullAddress}, ";

    //Add houses price
    terms = "$terms ${houseForm.price!.toInt()}, ";

    //Add houses currencies
    terms =
        "$terms ${houseForm.currency!.en}, ${houseForm.currency!.currency}, ${(houseForm.currency!.currency == 'XOF' || houseForm.currency!.currency == 'XAF') ? 'FCFA, F CFA, ' : ''}";

    //Add houses price type
    terms =
        "$terms ${houseForm.priceType!.fr}, par ${houseForm.priceType!.fr!.replaceAll("/", "")}, ";

    //Add houses city
    terms =
        "$terms ${houseForm.bathrooms! <= 1 ? 'douche' : '${houseForm.bathrooms} douches'}, ";

    //Add houses full address
    terms = "$terms ${houseForm.fullAddress}, ";

    //Add houses beds
    terms =
        "$terms ${houseForm.beds! <= 0 ? 'Entré couché' : houseForm.beds! == 1 ? 'chambre salon' : '${houseForm.beds!} chambres salon'}, ";

    //Add houses descriptions
    terms = "$terms ${houseForm.description}, ";

    //Add houses conditions
    terms = "$terms ${houseForm.conditions}, ";

    //Add houses expected tenants work
    terms = "$terms ${houseForm.occupation!.fr}, ";

    //Add houses expected tenants status
    terms = "$terms ${houseForm.maritalStatus!.fr}, ";

    //Add houses images descriptions
    terms = "$terms ${houseForm.imagesDescriptions!.join(', ')}, maison, ";

    //Add houses features
    for (var feature in houseForm.featuresName!) {
      terms = "$terms $feature, ";
    }

    return terms;
  }
}
