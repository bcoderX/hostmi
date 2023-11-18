import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/supabase/agencies/images/add_agency_picture.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/theme/app_style.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_property_basic_details.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_new_property_select_amenities_screen/add_new_property_select_amenities_screen.dart';
import 'package:hostmi/ui/screens/agency_screen/tabs/agency_manager_posts.dart';
import 'package:hostmi/ui/screens/agency_screen/tabs/contacts.dart';
import 'package:hostmi/ui/screens/agency_screen/tabs/manage_agency.dart';
import 'package:hostmi/ui/widgets/landloard_action_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AgencyManagerScreen extends StatefulWidget {
  const AgencyManagerScreen({Key? key, required this.agency}) : super(key: key);
  final AgencyModel agency;

  @override
  State<AgencyManagerScreen> createState() => _AgencyManagerScreenState();
}

class _AgencyManagerScreenState extends State<AgencyManagerScreen> {
  final SizedBox _spacer = const SizedBox(height: 10);
  int _selectedIndex = 0;
  bool _isAddingProfile = false;
  bool _isAddingCover = false;
  String _agencyCoverImage = "";
  String _agencyProfileImage = "";
  File? image;
  @override
  void initState() {
    // agency = AgencyModel.fromMap(widget.agency[0]["agencies"]);
    _agencyCoverImage = widget.agency.coverImageUrl ?? "";
    _agencyProfileImage = widget.agency.profileImageUrl ?? "";
    debugPrint(_agencyProfileImage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //   statusBarBrightness: Brightness.light,
        // ),
        title: Text(
          widget.agency.name!,
          style: const TextStyle(color: AppColor.black),
        ),
        actions: [
          TextButton.icon(
              onPressed: () {
                _showOptionDialog();
              },
              icon: const Icon(
                Icons.edit,
                color: AppColor.primary,
                size: 20,
              ),
              label: Text(AppLocalizations.of(context)!.edit))
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: AppColor.bottomBarGrey,
                              image: DecorationImage(
                                image: NetworkImage(
                                  _agencyCoverImage.isNotEmpty
                                      ? supabase.storage
                                          .from("agencies")
                                          .getPublicUrl(_agencyCoverImage)
                                      : "https://rwwurjrdtxmszqpwpocx.supabase.co/storage/v1/object/public/agencies/default_images/cover_placeholder.png",
                                ),
                                fit: BoxFit.cover,
                              ),
                              border: const Border(
                                bottom: BorderSide(
                                  width: 5.0,
                                  color: AppColor.listItemGrey,
                                ),
                              ),
                            ),
                          ),
                          _isAddingCover
                              ? Positioned.fill(
                                  child: Container(
                                    color: AppColor.black.withOpacity(.3),
                                    child: LoadingAnimationWidget
                                        .threeArchedCircle(
                                      color: AppColor.white,
                                      size: getSize(25),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                    ],
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            children: [
                              Container(
                                  height: 125,
                                  width: 125,
                                  decoration: BoxDecoration(
                                    image: _agencyProfileImage.isEmpty
                                        ? null
                                        : DecorationImage(
                                            image: NetworkImage(supabase.storage
                                                .from("agencies")
                                                .getPublicUrl(
                                                    _agencyProfileImage)),
                                            fit: BoxFit.cover,
                                          ),
                                    border: Border.all(
                                        color: AppColor.grey, width: 5.0),
                                    color: AppColor.primary,
                                  ),
                                  child: _agencyProfileImage.isEmpty
                                      ? const Icon(
                                          Icons.house,
                                          color: Colors.white,
                                          size: 50,
                                        )
                                      : null),
                              _isAddingProfile
                                  ? Positioned.fill(
                                      child: Container(
                                        color: AppColor.black.withOpacity(.3),
                                        child: LoadingAnimationWidget
                                            .threeArchedCircle(
                                          color: AppColor.white,
                                          size: getSize(25),
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                          const SizedBox(
                            width: 25,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                width: double.maxFinite,
                height: 60,
                decoration: const BoxDecoration(
                    color: AppColor.grey,
                    border: Border.symmetric(
                        horizontal: BorderSide(color: AppColor.grey))),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ActionButton(
                        icon: Icon(
                          Icons.pages,
                          color: _selectedIndex == 0
                              ? AppColor.white
                              : Colors.grey[800],
                          size: 18.0,
                        ),
                        text: "Publication",
                        backgroundColor:
                            _selectedIndex == 0 ? AppColor.primary : null,
                        foregroundColor:
                            _selectedIndex == 0 ? AppColor.white : null,
                        onPressed: () {
                          setSelectedIndex(0);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (BuildContext context) {
                          //   return const AddHouse1();
                          // }));
                        },
                      ),
                      ActionButton(
                        icon: Icon(
                          Icons.contact_page,
                          color: _selectedIndex == 1
                              ? AppColor.white
                              : Colors.grey[800],
                          size: 18.0,
                        ),
                        text: "Contacts",
                        backgroundColor:
                            _selectedIndex == 1 ? AppColor.primary : null,
                        foregroundColor:
                            _selectedIndex == 1 ? AppColor.white : null,
                        onPressed: () {
                          setSelectedIndex(1);
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (BuildContext context) {
                          //   return const AddHouse1();
                          // }));
                        },
                      ),
                      ActionButton(
                        icon: Icon(
                          Icons.settings,
                          color: _selectedIndex == 2
                              ? AppColor.white
                              : Colors.grey[800],
                          size: 18.0,
                        ),
                        text: AppLocalizations.of(context)!.manage,
                        backgroundColor:
                            _selectedIndex == 2 ? AppColor.primary : null,
                        foregroundColor:
                            _selectedIndex == 2 ? AppColor.white : null,
                        onPressed: () {
                          setSelectedIndex(2);
                        },
                      ),
                      ActionButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.grey[800],
                          size: 18.0,
                        ),
                        text: "Ajouter une propriété",
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            //return const AddHouse1();
                            return const AddNewPropertyBasicDetails();
                          }));
                        },
                      ),
                      ActionButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.grey[800],
                          size: 18.0,
                        ),
                        text: AppLocalizations.of(context)!.share,
                        onPressed: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (BuildContext context) {
                          //   return const AddNewPropertySelectAmenitiesScreen();
                          // }));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              _selectedIndex == 0
                  ? AgencyManagerPosts(
                      agencyId: widget.agency.id!,
                    )
                  : _selectedIndex == 1
                      ? AgencyContacts(agency: widget.agency)
                      : const ManageAgency(),
            ],
          ),
        ),
      ),
    );
  }

  void setSelectedIndex(int i) => setState(() {
        _selectedIndex = i;
      });

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
        image = File(croppedFile.path);
      } else {
        image = null;
      }
    }
  }

  Future<bool> _upload({
    required File? file,
    required String userId,
    required String agencyId,
    bool isProfileImage = true,
  }) async {
    // print(userId);
    if (image == null) {
      return false;
    }
    bool isAdded = false;
    setState(() {
      if (isProfileImage) {
        _isAddingProfile = true;
      } else {
        _isAddingCover = true;
      }
    });
    try {
      final bytes = await file!.readAsBytes();
      final String fileName = file.path.split(Platform.pathSeparator).last;
      final filePath = "$agencyId/images/$userId/$fileName";
      final imageUrlResponse =
          await supabase.storage.from('agencies').uploadBinary(
                filePath,
                bytes,
              );
      // print(imageUrlResponse);
      if (imageUrlResponse.replaceFirst(r"agencies/", "") == filePath) {
        // print("here we go");
        isAdded = await addAgencyPicture(
          agencyId: agencyId,
          imageUrl: filePath,
          isProfileImage: isProfileImage,
        );
        if (isAdded) {
          if (isProfileImage) {
            _isAddingProfile = false;
            _agencyProfileImage = filePath;
          } else {
            _isAddingCover = false;
            _agencyCoverImage = filePath;
          }
        }
      }
      setState(() {
        _isAddingProfile = false;
        _isAddingCover = false;
      });
      return isAdded;
      // widget.onUpload(imageUrlResponse);
    } on StorageException catch (error) {
      if (mounted) {
        setState(() {
          _isAddingProfile = false;
          _isAddingCover = false;
        });
        _pictureSavingErrorDialog(
            title: "Erreur d'enregistrement",
            content:
                "Une erreur s'est produite lors de l'enregistrement de l'image. Veuillez réessayer.");
        debugPrint(error.toString());
      }
    } catch (error) {
      setState(() {
        _isAddingProfile = false;
        _isAddingCover = false;
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

  _showOptionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text(
              "Modifier",
              style: AppStyle.txtManropeBold18,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Text(
                      "Modifier les détails de l'agence",
                      style: AppStyle.txtManrope16,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await pickImage();
                    await editImage(
                      const CropAspectRatio(ratioX: 1, ratioY: 1),
                    );
                    await _upload(
                      file: image,
                      userId: supabase.auth.currentUser!.id,
                      agencyId: widget.agency.id!,
                      isProfileImage: false,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Text(
                      "Modifier la photo de couverture",
                      style: AppStyle.txtManrope16,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await pickImage();
                    await editImage(
                      const CropAspectRatio(ratioX: 1, ratioY: 1),
                    );
                    await _upload(
                      file: image,
                      userId: supabase.auth.currentUser!.id,
                      agencyId: widget.agency.id!,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Text(
                      "Modifier la photo de profile",
                      style: AppStyle.txtManrope16,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Annuler")),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
