import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/app_bar/appbar_iconbutton_1.dart';
import 'package:hostmi/widgets/app_bar/appbar_subtitle.dart';
import 'package:hostmi/widgets/app_bar/custom_app_bar.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_phone_number.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class AddNewPropertyContactScreen extends StatelessWidget {
  Country selectedCountry = CountryPickerUtils.getCountryByPhoneCode('91');

  TextEditingController phoneNumberController = TextEditingController();

  AddNewPropertyContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.gray50,
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBar(
                height: getVerticalSize(48),
                leadingWidth: 64,
                leading: AppbarIconbutton1(
                    svgPath: ImageConstant.imgArrowleft,
                    margin: getMargin(left: 24),
                    onTap: () {
                      onTapArrowleft11(context);
                    }),
                centerTitle: true,
                title: AppbarSubtitle(text: "Add New Property")),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 24, top: 32, right: 24, bottom: 32),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding: getPadding(top: 6, bottom: 6),
                                child: Text("Contact",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppStyle.txtManropeSemiBold14Gray900)),
                            CustomButton(
                                height: getVerticalSize(33),
                                width: getHorizontalSize(79),
                                text: "07 / 08",
                                fontStyle: ButtonFontStyle
                                    .ManropeSemiBold14WhiteA700_1)
                          ]),
                      Padding(
                          padding: getPadding(top: 16),
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
                                      value: 0.87,
                                      backgroundColor: ColorConstant.blueGray50,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          ColorConstant.brown500))))),
                      Padding(
                          padding: getPadding(top: 26),
                          child: Text("Tell us a little about yourself",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeBold18.copyWith(
                                  letterSpacing: getHorizontalSize(0.2)))),
                      Padding(
                          padding: getPadding(top: 13),
                          child: CustomPhoneNumber(
                              country: selectedCountry,
                              controller: phoneNumberController,
                              onTap: (Country country) {
                                selectedCountry = country;
                              })),
                      SizedBox(
                          width: double.maxFinite,
                          child: Container(
                              width: getHorizontalSize(327),
                              margin: getMargin(top: 12, bottom: 5),
                              padding: getPadding(
                                  left: 20, top: 12, right: 20, bottom: 12),
                              decoration: AppDecoration.fillBluegray50.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder10),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: getPadding(top: 4),
                                        child: Text(
                                            "Is there anything else we should know?",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeMedium14Bluegray500))
                                  ])))
                    ])),
            bottomNavigationBar: Container(
                padding: getPadding(all: 24),
                decoration: AppDecoration.outlineBluegray1000f,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomButton(
                          height: getVerticalSize(56),
                          text: "Next",
                          shape: ButtonShape.RoundedBorder10,
                          padding: ButtonPadding.PaddingAll16,
                          fontStyle: ButtonFontStyle.ManropeBold16WhiteA700_1,
                          onTap: () {
                            onTapNext(context);
                          })
                    ]))));
  }

  onTapNext(BuildContext context) {
    //Navigator.pushNamed(context, AppRoutes.addNewPropertySelectAmenitiesScreen);
  }

  onTapArrowleft11(BuildContext context) {
    Navigator.pop(context);
  }
}
