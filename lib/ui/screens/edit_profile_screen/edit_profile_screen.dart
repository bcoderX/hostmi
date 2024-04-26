import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/country_model.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/models/gender.dart';
import 'package:hostmi/api/models/job.dart';
import 'package:hostmi/api/models/user_profile_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/api/supabase/rest/users/select_profile.dart';
import 'package:hostmi/api/supabase/rest/users/update_profile.dart';
import 'package:hostmi/api/supabase/rest/users/upload_profile_image.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/screens/loading_page.dart';
import 'package:hostmi/ui/widgets/datetime_picker_formfield.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_drop_down.dart';
import 'package:hostmi/widgets/custom_icon_button.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.next});
  final String next;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController lastnameController;
  late TextEditingController firstnameController;
  late TextEditingController dateController;
  late TextEditingController emailController;
  late TextEditingController passwordOneController;
  final GlobalKey<FormState> _formKey = GlobalKey();
  int? selectedCountry = 854;
  int? selectedGender;
  int? selectedJob;
  DateTime? birthday;
  File? image;
  bool _isAddingProfilePicture = false;
  bool _isUpdatingProfile = false;
  late Future<DatabaseResponse> _profileFuture;
  UserProfileModel? _user = UserProfileModel();
  String? imageUrl;
  @override
  void initState() {
    _profileFuture = getProfile(supabase.auth.currentUser!.id);
    lastnameController = TextEditingController();
    firstnameController = TextEditingController();
    dateController = TextEditingController();
    emailController = TextEditingController();
    passwordOneController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    lastnameController.dispose();
    firstnameController.dispose();
    dateController.dispose();
    emailController.dispose();
    passwordOneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        context.read<HostmiProvider>().getCountries();
        context.read<HostmiProvider>().getGenders();
        context.read<HostmiProvider>().getJobs();
      },
    );

    return FutureBuilder<DatabaseResponse>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const BallLoadingPage(loadingTitle: "Veuillez patientez...");
          }

          if (snapshot.hasError) {
            return const Center(
                child: Icon(
              Icons.replay_circle_filled_rounded,
              size: 40,
              color: AppColor.primary,
            ));
          }

          if (snapshot.hasData) {
            DatabaseResponse response = snapshot.data!;
            if (response.isSuccess) {
              _user = UserProfileModel.fromMap(data: response.list![0]);
              lastnameController.text = _user!.lastname ?? "";
              firstnameController.text = _user!.firstname ?? "";
              selectedCountry = _user!.country ?? 854;
              selectedGender = _user!.gender ?? 1;
              selectedJob = _user!.jobTitle ?? 1;
              birthday = _user!.birthday;
              dateController.text = birthday == null
                  ? ""
                  : DateFormat("dd/MM/yyyy").format(birthday!);
            } else {
              return Scaffold(
                body: InkWell(
                  onTap: () {
                    debugPrint("started");
                    _profileFuture = getProfile(supabase.auth.currentUser!.id)
                        .whenComplete(() {
                      setState(() {});
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.replay_circle_filled_rounded,
                            size: 40,
                            color: AppColor.primary,
                          ),
                          Text(
                            "Problème de connexion. Recharger la page",
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            return _user == null
                ? const Center(
                    child: Icon(
                      Icons.replay_circle_filled_rounded,
                      size: 40,
                      color: AppColor.primary,
                    ),
                  )
                : Scaffold(
                    backgroundColor: ColorConstant.gray50,
                    resizeToAvoidBottomInset: false,
                    appBar: AppBar(
                      title: const Text("Mis à jour du profile"),
                      backgroundColor: AppColor.grey,
                      foregroundColor: AppColor.black,
                      elevation: 0.0,
                    ),
                    body: Scrollbar(
                      child: SingleChildScrollView(
                        child: Container(
                            width: double.maxFinite,
                            padding: getPadding(
                                left: 24, top: 32, right: 24, bottom: 32),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                            height: getSize(100),
                                            width: getSize(100),
                                            child: Stack(
                                                alignment:
                                                    Alignment.bottomRight,
                                                children: [
                                                  Container(
                                                    width: getSize(100),
                                                    height: getSize(100),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                      color: AppColor.primary,
                                                    ),
                                                    child: imageUrl == null
                                                        ? _user!.avatarUrl ==
                                                                null
                                                            ? const Icon(
                                                                Icons.person,
                                                                color: Colors
                                                                    .white,
                                                              )
                                                            : ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            50.0),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  imageUrl: supabase
                                                                      .storage
                                                                      .from(
                                                                          "profiles")
                                                                      .getPublicUrl(
                                                                          _user!
                                                                              .avatarUrl!),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              )
                                                        : ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl: supabase
                                                                  .storage
                                                                  .from(
                                                                      "profiles")
                                                                  .getPublicUrl(
                                                                      imageUrl!),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                  ),
                                                  _isAddingProfilePicture
                                                      ? Positioned.fill(
                                                          child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        getSize(
                                                                            100)),
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    .2),
                                                          ),
                                                          child: const SizedBox(
                                                              width: 15,
                                                              height: 15,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: AppColor
                                                                    .white,
                                                              )),
                                                        ))
                                                      : const SizedBox(),
                                                  CustomIconButton(
                                                      height: 24,
                                                      width: 24,
                                                      onTap: () async {
                                                        await pickImage();
                                                        await editImage(
                                                            const CropAspectRatio(
                                                          ratioX: 1,
                                                          ratioY: 1,
                                                        ));
                                                        await _upload(
                                                          file: image,
                                                          userId: supabase.auth
                                                              .currentUser!.id,
                                                        );
                                                      },
                                                      variant: IconButtonVariant
                                                          .OutlineGray50,
                                                      shape: IconButtonShape
                                                          .RoundedBorder10,
                                                      padding: IconButtonPadding
                                                          .PaddingAll5,
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: const Icon(
                                                        Icons.camera_alt,
                                                        size: 10,
                                                        color: AppColor.white,
                                                      )),
                                                ]))),
                                    Padding(
                                        padding: getPadding(top: 33),
                                        child: Text("Nom",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeMedium12Bluegray500
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.4)))),
                                    CustomTextFormField(
                                      controller: lastnameController,
                                      hintText: "",
                                      margin: getMargin(top: 7),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length < 2) {
                                          return "Veuillez saisir un nom valide.";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    Padding(
                                      padding: getPadding(top: 33),
                                      child: Text(
                                        "Prénom(s)",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeMedium12Bluegray500
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.4)),
                                      ),
                                    ),
                                    CustomTextFormField(
                                      controller: firstnameController,
                                      hintText: "",
                                      margin: getMargin(top: 7),
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length < 2) {
                                          return "Votre prénom est invalide";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    Padding(
                                        padding: getPadding(top: 17),
                                        child: Text("Date de naissance",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeMedium12Bluegray500
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.4)))),
                                    DateTimeField(
                                      initialValue: birthday,
                                      onChanged: (value) {
                                        birthday = value;
                                      },
                                      format: DateFormat("dd/MM/yyyy"),
                                      controller: dateController,
                                      onShowPicker:
                                          (context, currentValue) async {
                                        return showDatePicker(
                                            context: context,
                                            firstDate: DateTime(1900),
                                            initialDate:
                                                currentValue ?? DateTime.now(),
                                            lastDate: DateTime(2100));
                                      },
                                      validator: (value) {
                                        if (value == null) {
                                          return "Ce champ est obligatoire";
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    Padding(
                                        padding: getPadding(top: 17),
                                        child: Text("Sexe",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeMedium12Bluegray500
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.4)))),
                                    CustomDropDown<Gender>(
                                        value: Gender(id: selectedGender),
                                        validator: (value) {
                                          if (value == null) {
                                            return "Ce champ est obligatoire";
                                          } else {
                                            return null;
                                          }
                                        },
                                        icon: Container(
                                            margin:
                                                getMargin(left: 30, right: 16),
                                            child: CustomImageView(
                                                svgPath: ImageConstant
                                                    .imgArrowdownGray900)),
                                        margin: getMargin(top: 12),
                                        variant: DropDownVariant.FillBluegray50,
                                        fontStyle: DropDownFontStyle
                                            .ManropeMedium14Bluegray500,
                                        items: context
                                            .watch<HostmiProvider>()
                                            .gendersList
                                            .where((element) =>
                                                element["en"].toString() !=
                                                "Any")
                                            .toList()
                                            .map((gender) {
                                          return DropdownMenuItem<Gender>(
                                              value:
                                                  Gender.fromMap(data: gender),
                                              child: Text(
                                                gender["fr"].toString(),
                                                overflow: TextOverflow.ellipsis,
                                              ));
                                        }).toList(),
                                        onChanged: (value) {
                                          selectedGender = value.id!;
                                        }),
                                    Padding(
                                        padding: getPadding(top: 17),
                                        child: Text("Ocupations",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeMedium12Bluegray500
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.4)))),
                                    CustomDropDown<Job>(
                                        value: Job(id: selectedJob),
                                        validator: (value) {
                                          if (value == null) {
                                            return "Ce champ est obligatoire";
                                          } else {
                                            return null;
                                          }
                                        },
                                        //focusNode: FocusNode(),
                                        icon: Container(
                                            margin:
                                                getMargin(left: 30, right: 16),
                                            child: CustomImageView(
                                                svgPath: ImageConstant
                                                    .imgArrowdownGray900)),
                                        margin: getMargin(top: 12),
                                        variant: DropDownVariant.FillBluegray50,
                                        fontStyle: DropDownFontStyle
                                            .ManropeMedium14Bluegray500,
                                        items: context
                                            .watch<HostmiProvider>()
                                            .jobsList
                                            .where((element) =>
                                                element["en"].toString() !=
                                                "Any")
                                            .toList()
                                            .map((job) {
                                          return DropdownMenuItem<Job>(
                                              value: Job.fromMap(data: job),
                                              child: Text(
                                                job["fr"].toString(),
                                                overflow: TextOverflow.ellipsis,
                                              ));
                                        }).toList(),
                                        onChanged: (value) {
                                          selectedJob = value.id!;
                                        }),
                                    Padding(
                                        padding: getPadding(top: 17),
                                        child: Text("Pays",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeMedium12Bluegray500
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.4)))),
                                    CustomDropDown<Country>(
                                        validator: (value) {
                                          if (value == null) {
                                            return "Ce champ est obligatoire";
                                          } else {
                                            return null;
                                          }
                                        },
                                        value: Country(id: selectedCountry!),
                                        icon: Container(
                                            margin:
                                                getMargin(left: 30, right: 16),
                                            child: CustomImageView(
                                                svgPath: ImageConstant
                                                    .imgArrowdownGray900)),
                                        margin: getMargin(top: 12),
                                        variant: DropDownVariant.FillBluegray50,
                                        fontStyle: DropDownFontStyle
                                            .ManropeMedium14Bluegray500,
                                        items: context
                                            .watch<HostmiProvider>()
                                            .countriesList
                                            .map((country) {
                                          return DropdownMenuItem<Country>(
                                              value: Country.fromMap(country),
                                              child: Text(
                                                country["fr"].toString(),
                                                overflow: TextOverflow.ellipsis,
                                              ));
                                        }).toList(),
                                        onChanged: (value) {
                                          selectedCountry = value.id;
                                        }),
                                  ]),
                            )),
                      ),
                    ),
                    bottomNavigationBar: Container(
                        padding: getPadding(all: 24),
                        decoration: AppDecoration.outlineBluegray1000f,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CustomButton(
                                  onTap: _isUpdatingProfile
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _user = UserProfileModel(
                                                id: supabase
                                                    .auth.currentUser!.id,
                                                jobTitle: selectedJob,
                                                firstname: firstnameController
                                                    .text
                                                    .trim(),
                                                lastname: lastnameController
                                                    .text
                                                    .trim(),
                                                country: selectedCountry,
                                                gender: selectedGender,
                                                birthday: birthday);
                                            setState(() {
                                              _isUpdatingProfile = true;
                                            });
                                            bool isUpdated =
                                                await updateProfile(
                                                    profile: _user!);
                                            if (isUpdated) {
                                              setIsProfileCompleted(true);

                                              _navigateTo(
                                                  "/${widget.next == 'profile' ? 'profile' : widget.next}");
                                            }
                                            setState(() {
                                              _isUpdatingProfile = false;
                                            });
                                          }
                                        },
                                  height: getVerticalSize(56),
                                  text: _isUpdatingProfile
                                      ? "Enregistrement..."
                                      : "Enregistrer",
                                  shape: ButtonShape.RoundedBorder10,
                                  padding: ButtonPadding.PaddingAll16,
                                  fontStyle:
                                      ButtonFontStyle.ManropeBold16WhiteA700_1)
                            ])));
          }
          return const Center(
              child: Icon(
            Icons.replay_circle_filled_rounded,
            size: 40,
            color: AppColor.primary,
          ));
        });
  }

  _navigateTo(String route) {
    context.push(route);
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = await compressFile(File(image.path));
      setState(() {
        this.image = imageTemp;
      });
    } on PlatformException {}
  }

  Future<File> compressFile(File file) async {
    final filePath = file.absolute.path;
    var lastSeparator = filePath.lastIndexOf(Platform.pathSeparator);
// file.rename(newPath)
    // final lastIndex = filePath.lastIndexOf(file.);
    final splitted = filePath.substring(0, lastSeparator + 1);
    final outPath = "${splitted}progile.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      format: CompressFormat.jpeg,
      quality: 50,
    );

    return File(result!.path);
  }

  Future<void> editImage(CropAspectRatio? aspectRatio) async {
    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        aspectRatio: aspectRatio,
        sourcePath: image!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Modifier l'image",
            toolbarColor: AppColor.grey,
            toolbarWidgetColor: AppColor.black,
            activeControlsWidgetColor: AppColor.primary,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true,
            backgroundColor: AppColor.grey,
            dimmedLayerColor: AppColor.grey.withOpacity(.5),
          ),
          IOSUiSettings(
            title: "Modifier l'image",
            aspectRatioLockEnabled: true,
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
        image = File(croppedFile.path);
      } else {
        image = null;
      }
    }
  }

  Future<bool> _upload({
    required File? file,
    required String userId,
  }) async {
    // print(userId);
    if (image == null) {
      return false;
    }
    bool isAdded = false;
    setState(() {
      _isAddingProfilePicture = true;
    });
    try {
      final bytes = await file!.readAsBytes();
      final String fileName = file.path.split(Platform.pathSeparator).last;
      final filePath = "$userId/avatars/$fileName";
      final imageUrlResponse =
          await supabase.storage.from('profiles').uploadBinary(
                filePath,
                bytes,
              );
      // print(imageUrlResponse);
      if (imageUrlResponse.replaceFirst(r"profiles/", "") == filePath) {
        // print("here we go");
        isAdded = await addProfilePicture(
          userId: userId,
          imageUrl: filePath,
        );
        if (isAdded) {
          setState(() {
            imageUrl = filePath;
          });
        }
      }
      setState(() {
        _isAddingProfilePicture = false;
      });
      return isAdded;
      // widget.onUpload(imageUrlResponse);
    } on StorageException catch (error) {
      if (mounted) {
        setState(() {
          _isAddingProfilePicture = false;
        });
        _pictureSavingErrorDialog(
            title: "Erreur d'enregistrement",
            content:
                "Une erreur s'est produite lors de l'enregistrement de l'image. Veuillez réessayer.");
        debugPrint(error.toString());
      }
    } catch (error) {
      setState(() {
        _isAddingProfilePicture = false;
      });
      if (mounted) {
        _pictureSavingErrorDialog(
            title: "Erreur d'enregistrement",
            content:
                "Une erreur s'produite lors de l'enregistrement de l'image. Veuillez réessayer.");
        debugPrint(error.toString());
      }
    }
    return false;
  }

  _pictureSavingErrorDialog({
    required String title,
    required String content,
  }) {
    showErrorDialog(title: title, content: content, context: context);
  }
}
