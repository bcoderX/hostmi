import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/app_bar/appbar_iconbutton_1.dart';
import 'package:hostmi/widgets/app_bar/appbar_subtitle.dart';
import 'package:hostmi/widgets/app_bar/custom_app_bar.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class AddNewPropertyTimeToSellScreen extends StatelessWidget {
  TextEditingController durationController = TextEditingController();

  TextEditingController streetaddressController = TextEditingController();

  TextEditingController durationOneController = TextEditingController();

  TextEditingController durationTwoController = TextEditingController();

  TextEditingController durationThreeController = TextEditingController();

  TextEditingController streetaddressOneController = TextEditingController();

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
                      onTapArrowleft7(context);
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
                                child: Text("Time to sell",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppStyle.txtManropeSemiBold14Gray900)),
                            CustomButton(
                                height: getVerticalSize(33),
                                width: getHorizontalSize(78),
                                text: "03 / 08",
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
                                      value: 0.37,
                                      backgroundColor: ColorConstant.blueGray50,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          ColorConstant.brown500))))),
                      Padding(
                          padding: getPadding(top: 26),
                          child: Text("How soon do you want to sell?",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeBold18.copyWith(
                                  letterSpacing: getHorizontalSize(0.2)))),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: durationController,
                          hintText: "Within 3 days",
                          margin: getMargin(top: 13),
                          variant: TextFormFieldVariant.OutlineGray300,
                          fontStyle:
                              TextFormFieldFontStyle.ManropeSemiBold14Gray900),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: streetaddressController,
                          hintText: "Within 1 week",
                          margin: getMargin(top: 8),
                          variant: TextFormFieldVariant.OutlineGray300,
                          fontStyle:
                              TextFormFieldFontStyle.ManropeSemiBold14Gray900),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: durationOneController,
                          hintText: "Within 1 month",
                          margin: getMargin(top: 8),
                          variant: TextFormFieldVariant.OutlineGray300,
                          fontStyle:
                              TextFormFieldFontStyle.ManropeSemiBold14Gray900),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: durationTwoController,
                          hintText: "Within 2 months",
                          margin: getMargin(top: 8),
                          variant: TextFormFieldVariant.OutlineGray300,
                          fontStyle:
                              TextFormFieldFontStyle.ManropeSemiBold14Gray900),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: durationThreeController,
                          hintText: "In more than 2 months",
                          margin: getMargin(top: 8),
                          variant: TextFormFieldVariant.OutlineGray300,
                          fontStyle:
                              TextFormFieldFontStyle.ManropeSemiBold14Gray900),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: streetaddressOneController,
                          hintText: "I’m not sure",
                          margin: getMargin(top: 8, bottom: 5),
                          variant: TextFormFieldVariant.OutlineGray300,
                          fontStyle:
                              TextFormFieldFontStyle.ManropeSemiBold14Gray900,
                          textInputAction: TextInputAction.done)
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
    //Navigator.pushNamed(
       // context, AppRoutes.addNewPropertyReasonSellingHomeScreen);
  }

  onTapArrowleft7(BuildContext context) {
    Navigator.pop(context);
  }
}
