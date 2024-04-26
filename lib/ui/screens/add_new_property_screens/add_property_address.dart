import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hostmi/api/models/country_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/utils/check_connection_and_do.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_new_property_select_amenities_screen/add_new_property_select_amenities_screen.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_drop_down.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:safe_device/safe_device.dart';

class AddPropertyAddressScreen extends StatefulWidget {
  const AddPropertyAddressScreen({super.key});

  @override
  State<AddPropertyAddressScreen> createState() =>
      _AddPropertyAddressScreenState();
}

class _AddPropertyAddressScreenState extends State<AddPropertyAddressScreen> {
  final GlobalKey<FormState> _formState = GlobalKey();
  TextEditingController sectorController = TextEditingController();

  TextEditingController quarterController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  TextEditingController countryController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  TextEditingController longitudeController = TextEditingController();

  TextEditingController latitudeController = TextEditingController();
  bool _isGettingPosition = false;
  Country selectedCountry = Country(
    id: 854,
    en: "Burkina Faso",
    fr: "Burkina Faso",
  );
  final SizedBox _spacer = const SizedBox(height: 15);

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      checkConnectionAndDo(() {
        context.read<HostmiProvider>().getCountries();
      });
    });
    return Scaffold(
      backgroundColor: ColorConstant.gray50,
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        title: Text(AppLocalizations.of(context)!.addHouse),
        actions: const [],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Form(
            key: _formState,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                              padding: getPadding(top: 7, bottom: 5),
                              child: Text("Addresse",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtManropeSemiBold14Gray900)),
                          CustomButton(
                              height: getVerticalSize(33),
                              width: getHorizontalSize(76),
                              text: "02 / 04",
                              fontStyle:
                                  ButtonFontStyle.ManropeSemiBold14WhiteA700_1)
                        ]),
                    Padding(
                        padding: getPadding(top: 16),
                        child: Container(
                            height: getVerticalSize(6),
                            width: getHorizontalSize(327),
                            decoration: BoxDecoration(
                                color: ColorConstant.blueGray50,
                                borderRadius: BorderRadius.circular(
                                    getHorizontalSize(10.0))),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    getHorizontalSize(10.0)),
                                child: LinearProgressIndicator(
                                    value: 0.5,
                                    backgroundColor: ColorConstant.blueGray50,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        ColorConstant.brown500))))),
                    Padding(
                        padding: getPadding(top: 26),
                        child: Text("L'addresse de la propriété",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtManropeBold18.copyWith(
                                letterSpacing: getHorizontalSize(0.2)))),
                    _spacer,
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Secteur",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: AppColor.listItemGrey,
                        ),
                      ),
                    ),
                    CustomTextFormField(
                      //focusNode: FocusNode(),
                      controller: sectorController,
                      hintText: "0",
                      margin: getMargin(top: 13),
                      textInputType: TextInputType.number,
                      maxLength: 3,
                    ),
                    _spacer,
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Quartier",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: AppColor.listItemGrey,
                        ),
                      ),
                    ),
                    CustomTextFormField(
                      controller: quarterController,
                      hintText: "Nom du quartier",
                      margin: getMargin(top: 12),
                      maxLength: 50,
                    ),
                    _spacer,
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Ville",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: AppColor.listItemGrey,
                        ),
                      ),
                    ),
                    CustomTextFormField(
                      //focusNode: FocusNode(),
                      controller: cityController,
                      hintText: "Nom de la ville",
                      margin: getMargin(top: 12),
                      validator: (value) {
                        if (value!.length < 2 ||
                            !RegExp(r"[a-zA-Z]+").hasMatch(value)) {
                          return "Le nom de la ville est invalide";
                        }
                        return null;
                      },
                    ),
                    _spacer,
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Pays",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: AppColor.listItemGrey,
                        ),
                      ),
                    ),
                    CustomDropDown<Country>(
                        value: context.read<HostmiProvider>().houseForm.country,
                        //focusNode: FocusNode(),
                        icon: Container(
                            margin: getMargin(left: 30, right: 16),
                            child: CustomImageView(
                                svgPath: ImageConstant.imgArrowdownGray900)),
                        margin: getMargin(top: 12),
                        variant: DropDownVariant.FillBluegray50,
                        fontStyle: DropDownFontStyle.ManropeMedium14Bluegray500,
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
                          selectedCountry = value;
                        }),
                    _spacer,
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Addresse complète",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: AppColor.listItemGrey,
                        ),
                      ),
                    ),
                    CustomTextFormField(
                      //focusNode: FocusNode(),
                      controller: addressController,
                      hintText: "Rue 9.12, secteur 9, Koudougou, Burkina Faso",
                      margin: getMargin(top: 12, bottom: 5),
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.streetAddress,
                      maxLength: 40,
                    ),
                    _spacer,
                    Container(
                      width: double.infinity,
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.5, horizontal: 5.0),
                      color: AppColor.grey,
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "Coordonnées GPS (Facultatif)",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: AppColor.listItemGrey,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _isGettingPosition
                                ? null
                                : () {
                                    _checkPermission(context);
                                  },
                            child: _isGettingPosition
                                ? const SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator())
                                : const Text("Position Actuelle"),
                          )
                        ],
                      ),
                    ),
                    const Text(
                      "Cela permettra d'afficher votre maison sur la carte. Cliquer sur 'Postion Actuelle' si ce téléphone est au niveau de la maison que vous êtes entrain de poster.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    _spacer,
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Longitude",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: AppColor.listItemGrey,
                        ),
                      ),
                    ),
                    CustomTextFormField(
                        //focusNode: FocusNode(),
                        controller: longitudeController,
                        hintText: "0",
                        margin: getMargin(top: 12, bottom: 5),
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.number,
                    ),
                    _spacer,
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        "Latitude",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: AppColor.listItemGrey,
                        ),
                      ),
                    ),
                    CustomTextFormField(
                      controller: latitudeController,
                      hintText: "0",
                      margin: getMargin(top: 12, bottom: 5),
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.number,
                    ),
                    _spacer,
                    Row(
                      children: [
                        Expanded(
                          child: DefaultAppButton(
                            color: Colors.grey[200],
                            textColor: Colors.grey[600],
                            text: "Retour",
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        SizedBox(width: 15,),
                        Expanded(
                          child: DefaultAppButton(
                            text: "Suivant",
                            onPressed: () {
                              onTapNext(context);
                            },
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  onTapNext(BuildContext context) {
    context.read<HostmiProvider>().houseForm.sector =
        int.tryParse(sectorController.text.trim()) ?? 0;
    context.read<HostmiProvider>().houseForm.quarter =
        quarterController.text.trim();
    context.read<HostmiProvider>().houseForm.city = cityController.text.trim();
    context.read<HostmiProvider>().houseForm.country = selectedCountry;
    context.read<HostmiProvider>().houseForm.fullAddress =
        addressController.text.trim();
    context.read<HostmiProvider>().houseForm.sector =
        int.tryParse(sectorController.text.trim()) ?? 0;
    context.read<HostmiProvider>().houseForm.longitude =
        double.tryParse(longitudeController.text.trim()) ?? 0;
    context.read<HostmiProvider>().houseForm.latitude =
        double.tryParse(latitudeController.text.trim()) ?? 0;
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const AddNewPropertySelectAmenitiesScreen();
    }));
  }

  void _checkPermission(BuildContext context) async {
    setState(() {
      _isGettingPosition = true;
    });
    bool isRealDevice = await SafeDevice.isRealDevice;
    if (isRealDevice) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);
        setState(() {
          latitudeController.text = position.latitude.toString();
          longitudeController.text = position.longitude.toString();
        });
      } else {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          try {
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.bestForNavigation);
            latitudeController.text = position.latitude.toString();
            longitudeController.text = position.longitude.toString();
          } catch (e) {
            debugPrint(e.toString());
          }
        } else {
          reAskPermission();
        }
      }
    }

    latitudeController.text = "12.253609";
    longitudeController.text = "-2.378845";
    setState(() {
      _isGettingPosition = false;
    });
  }

  reAskPermission() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Demande d'accès"),
            content: const Text(
                "Veuillez cliquer sur autoriser pour choisir la position actuelles"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Annuler"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _checkPermission(context);
                },
                child: const Text("D'accord"),
              ),
            ],
          );
        });
  }

  onTapCurrentPositin(BuildContext context) {
    Navigator.pop(context);
  }
}
