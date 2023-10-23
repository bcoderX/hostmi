import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/providers/locale_provider.dart';
import 'package:hostmi/core/utils/color_constant.dart';
import 'package:hostmi/core/utils/image_constant.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/theme/app_style.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_property_address.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/ui/widgets/landloard_action_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_drop_down.dart';
import 'package:hostmi/widgets/custom_image_view.dart';
import 'package:hostmi/widgets/custom_radio_button.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SetPropertyBasicDetails extends StatefulWidget {
  const SetPropertyBasicDetails({super.key});

  @override
  State<SetPropertyBasicDetails> createState() =>
      _SetPropertyBasicDetailsState();
}

class _SetPropertyBasicDetailsState extends State<SetPropertyBasicDetails> {
  final SizedBox _spacer = const SizedBox(height: 25);
  File? mainImage;
  File? mainCroppedImage;
  String selectedHouseType = "1";
  String selectedHouseCategory = "1";
  String selectedPriceType = "1";
  String selectedCurrency = "159";
  TextEditingController numberOfBeds = TextEditingController();
  TextEditingController numberOfBaths = TextEditingController();
  TextEditingController price = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HostmiProvider>().getPriceTypes();
      context.read<HostmiProvider>().getHouseTypes();
      context.read<HostmiProvider>().getHouseCategories();
      context.read<HostmiProvider>().getCurrencies();
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColor.grey,
            statusBarIconBrightness: Brightness.dark),
        title: Text(AppLocalizations.of(context)!.addHouse),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Padding(
                      padding: getPadding(top: 7, bottom: 5),
                      child: Text("Information de base",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtManropeSemiBold14Gray900)),
                  CustomButton(
                      height: getVerticalSize(33),
                      width: getHorizontalSize(76),
                      text: "01 / 04",
                      fontStyle: ButtonFontStyle.ManropeSemiBold14WhiteA700_1)
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
                      borderRadius: BorderRadius.circular(getHorizontalSize(3)),
                      child: LinearProgressIndicator(
                        value: 0.25,
                        backgroundColor: ColorConstant.blueGray50,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            ColorConstant.brown500),
                      ),
                    ),
                  ),
                ),
                _spacer,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Photo principale (Facultatif)",
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
                        "La photo principale est la première photo que les gens vont voir avant de chercher plus de détails. ",
                        style: TextStyle(
                          color: AppColor.listItemGrey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {
                              pickImage();
                            },
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: mainCroppedImage == null
                                      ? const AssetImage(
                                          "assets/images/image_not_found.png")
                                      : FileImage(mainCroppedImage!)
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
                                    await pickImage();
                                  },
                                ),
                                ActionButton(
                                  icon: const Icon(Icons.edit),
                                  text: "Modifier",
                                  onPressed: () async {
                                    await _cropImage(context, 0);
                                  },
                                ),
                                ActionButton(
                                  icon: const Icon(Icons.delete),
                                  text: "Suprimer",
                                  onPressed: () {
                                    setState(() {
                                      mainImage = null;
                                      mainCroppedImage = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                _spacer,
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 15.0),
                  height: 15,
                  color: Colors.grey[200],
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Choisir le type de maison",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: AppColor.listItemGrey,
                    ),
                  ),
                ),
                CustomDropDown(
                    value: context
                        .read<HostmiProvider>()
                        .houseForm
                        .houseType
                        .toString(),
                    focusNode: FocusNode(),
                    icon: Container(
                        margin: getMargin(left: 30, right: 16),
                        child: CustomImageView(
                            svgPath: ImageConstant.imgArrowdownGray900)),
                    hintText: "Choisir un type de maison",
                    margin: getMargin(top: 12),
                    variant: DropDownVariant.FillBluegray50,
                    fontStyle: DropDownFontStyle.ManropeMedium14Bluegray500,
                    items: context
                        .watch<HostmiProvider>()
                        .houseTypesList
                        .map((houseType) {
                      return DropdownMenuItem<String>(
                          value: houseType["id"].toString(),
                          child: Text(
                            houseType["fr"].toString(),
                            overflow: TextOverflow.ellipsis,
                          ));
                    }).toList(),
                    onChanged: (value) {
                      selectedHouseType = value;
                    }),
                _spacer,
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Choisir une categorie de maison",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: AppColor.listItemGrey),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomDropDown(
                    value: context
                        .read<HostmiProvider>()
                        .houseForm
                        .houseCategory
                        .toString(),
                    focusNode: FocusNode(),
                    icon: Container(
                        margin: getMargin(left: 30, right: 16),
                        child: CustomImageView(
                            svgPath: ImageConstant.imgArrowdownGray900)),
                    hintText: "Choisir une catégorie",
                    margin: getMargin(top: 12),
                    variant: DropDownVariant.FillBluegray50,
                    fontStyle: DropDownFontStyle.ManropeMedium14Bluegray500,
                    items: context
                        .watch<HostmiProvider>()
                        .houseCategoriesList
                        .map((category) {
                      return DropdownMenuItem<String>(
                          value: category["id"].toString(),
                          child: Text(
                            category["fr"].toString(),
                            overflow: TextOverflow.ellipsis,
                          ));
                    }).toList(),
                    onChanged: (value) {
                      selectedHouseCategory = value;
                    }),
                _spacer,
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 15.0),
                  height: 15,
                  color: Colors.grey[200],
                ),
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Nombre de chambres",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: AppColor.listItemGrey,
                    ),
                  ),
                ),
                CustomTextFormField(
                  //focusNode: FocusNode(),
                  controller: numberOfBeds,
                  hintText: "0",
                  margin: getMargin(top: 13),
                ),
                _spacer,
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Nombre de douches",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: AppColor.listItemGrey,
                    ),
                  ),
                ),
                CustomTextFormField(
                  //focusNode: FocusNode(),
                  controller: numberOfBaths,
                  hintText: "0",
                  margin: getMargin(top: 13),
                ),
                _spacer,
                Container(
                  width: double.infinity,
                  height: 15,
                  color: Colors.grey[200],
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        "Prix",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: AppColor.listItemGrey,
                        ),
                      ),
                    ),
                    Expanded(
                        child: DropdownButtonFormField<String>(
                      value: context
                          .read<HostmiProvider>()
                          .houseForm
                          .priceType
                          .toString(),
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      items: context
                          .watch<HostmiProvider>()
                          .priceTypesList
                          .map((priceType) {
                        return DropdownMenuItem<String>(
                            value: priceType["id"].toString(),
                            child: Text(
                              priceType["fr"].toString(),
                              overflow: TextOverflow.ellipsis,
                            ));
                      }).toList(),
                      onChanged: (value) {
                        selectedPriceType = value!;
                      },
                    ))
                  ],
                ),
                CustomTextFormField(
                  //variant: TextFormFieldVariant.OutlineRed,
                  //focusNode: FocusNode(),
                  controller: price,
                  hintText: "0",
                  margin: getMargin(top: 13),
                ),
                _spacer,
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Monnaie utilisée",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: AppColor.listItemGrey),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomDropDown(
                    value: context
                        .read<HostmiProvider>()
                        .houseForm
                        .currency
                        .toString(),
                    //focusNode: FocusNode(),
                    icon: Container(
                        margin: getMargin(left: 30, right: 16),
                        child: CustomImageView(
                            svgPath: ImageConstant.imgArrowdownGray900)),
                    hintText: "Choisir une monnaie",
                    margin: getMargin(top: 12),
                    variant: DropDownVariant.FillBluegray50,
                    fontStyle: DropDownFontStyle.ManropeMedium14Bluegray500,
                    items: context
                        .watch<HostmiProvider>()
                        .currenciesList
                        .map((currency) {
                      return DropdownMenuItem<String>(
                          value: currency["id"].toString(),
                          child: Text(
                            "${currency["currency"] + ' - ' + currency["en"]}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ));
                    }).toList(),
                    onChanged: (value) {
                      selectedCurrency = value;
                    }),
                _spacer,
                DefaultAppButton(
                  text: "Suivant",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          context.read<HostmiProvider>().houseForm.mainImage =
                              mainCroppedImage;
                          context.read<HostmiProvider>().houseForm.houseType =
                              int.tryParse(selectedHouseType) ?? 1;
                          context
                                  .read<HostmiProvider>()
                                  .houseForm
                                  .houseCategory =
                              int.tryParse(selectedHouseCategory) ?? 1;
                          context.read<HostmiProvider>().houseForm.currency =
                              int.tryParse(selectedCurrency) ?? 159;
                          context.read<HostmiProvider>().houseForm.beds =
                              int.tryParse(numberOfBeds.text.trim()) ?? 0;
                          context.read<HostmiProvider>().houseForm.bathrooms =
                              int.tryParse(numberOfBaths.text.trim()) ?? 0;
                          context.read<HostmiProvider>().houseForm.priceType =
                              int.tryParse(selectedPriceType) ?? 1;
                          context.read<HostmiProvider>().houseForm.price =
                              int.tryParse(price.text.trim()) ?? 0;
                          return const AddPropertyAddressScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemp = await compressFile(File(image.path));
      setState(() {
        mainImage = imageTemp;
        mainCroppedImage = imageTemp;
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
    if (mainImage != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: mainImage!.path,
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
          mainCroppedImage = File(croppedFile.path);
        });
      }
    }
  }
}
