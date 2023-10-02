import 'package:flutter/services.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';

import '../add_new_property_select_amenities_screen/widgets/options_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewPropertySelectAmenitiesScreen extends StatefulWidget {
  const AddNewPropertySelectAmenitiesScreen({super.key});

  @override
  State<AddNewPropertySelectAmenitiesScreen> createState() =>
      _AddNewPropertySelectAmenitiesScreenState();
}

class _AddNewPropertySelectAmenitiesScreenState
    extends State<AddNewPropertySelectAmenitiesScreen> {
  final List<int> selected = [];

  final List<Map<String, dynamic>> _amenities = [
    {
      "id": 1,
      "en": "Current",
      "fr": "Courant",
    },
    {
      "id": 2,
      "en": "Water common counter",
      "fr": "Eau compteur commun",
    },
    {
      "id": 3,
      "en": "Water individual counter",
      "fr": "Eau compteur individuel",
    },
    {
      "id": 4,
      "en": "Boring Water",
      "fr": "Eau forage",
    },
    {
      "id": 5,
      "en": "Current",
      "fr": "Courant",
    },
    {
      "id": 6,
      "en": "Kitchen",
      "fr": "Cuisine",
    },
    {
      "id": 7,
      "en": "Trees",
      "fr": "Arbres",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.gray50,
        appBar: AppBar(
          backgroundColor: AppColor.grey,
          foregroundColor: AppColor.black,
          elevation: 0.0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: AppColor.grey,
              statusBarIconBrightness: Brightness.dark),
          title: Text(AppLocalizations.of(context)!.addHouse),
          actions: const [],
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
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
                            padding: getPadding(top: 6, bottom: 6),
                            child: Text("Caractéristiques",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeSemiBold14Gray900)),
                        CustomButton(
                            height: getVerticalSize(33),
                            width: getHorizontalSize(79),
                            text: "03 / 04",
                            fontStyle:
                                ButtonFontStyle.ManropeSemiBold14WhiteA700_1)
                      ]),
                  Container(
                      height: getVerticalSize(6),
                      width: getHorizontalSize(327),
                      margin: getMargin(top: 16),
                      child: Stack(alignment: Alignment.center, children: [
                        Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                                width: getHorizontalSize(327),
                                child: Divider(
                                    height: getVerticalSize(6),
                                    thickness: getVerticalSize(6),
                                    color: ColorConstant.blueGray50))),
                        Align(
                            alignment: Alignment.center,
                            child: Container(
                                height: getVerticalSize(6),
                                width: getHorizontalSize(327),
                                decoration: BoxDecoration(
                                    color: ColorConstant.blueGray50,
                                    borderRadius: BorderRadius.circular(
                                        getHorizontalSize(3))),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      getHorizontalSize(3)),
                                  child: LinearProgressIndicator(
                                      value: 0.75,
                                      backgroundColor: ColorConstant.blueGray50,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          ColorConstant.brown500)),
                                )))
                      ])),
                  Padding(
                      padding: getPadding(top: 24),
                      child: Text("Choisir les caractéristiques",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtManropeBold18.copyWith(
                              letterSpacing: getHorizontalSize(0.2)))),
                  Padding(
                    padding: getPadding(top: 15, bottom: 5),
                    child: Wrap(
                      runSpacing: getVerticalSize(5),
                      spacing: getHorizontalSize(5),
                      children: List<Widget>.generate(
                        _amenities.length,
                        (index) => OptionsItemWidget(
                          amenity: _amenities[index],
                          selected: selected,
                          onPressed: () => onSelected(_amenities[index]["id"]),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: getPadding(top: 24),
                      child: Text("Description (Facultatif)",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtManropeBold18.copyWith(
                              letterSpacing: getHorizontalSize(0.2)))),
                  CustomTextFormField(
                    focusNode: FocusNode(),
                    controller: TextEditingController(),
                    hintText: "Faites une petite description de la maison",
                    margin: getMargin(top: 12),
                    textInputType: TextInputType.text,
                    maxLines: 6,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const Padding(
          padding: EdgeInsets.all(8.0),
          child: DefaultAppButton(text: "Enregistrer"),
        ),
      ),
    );
  }

  onTapNext(BuildContext context) {
    //Navigator.pushNamed(context, AppRoutes.addNewPropertyDetailsScreen);
  }

  onTapArrowleft12(BuildContext context) {
    Navigator.pop(context);
  }

  onSelected(int index) {
    setState(() {
      if (selected.contains(index)) {
        selected.remove(index);
      } else {
        selected.add(index);
      }
    });
  }
}
