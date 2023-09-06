import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/app_bar/appbar_iconbutton_1.dart';
import 'package:hostmi/widgets/app_bar/appbar_subtitle.dart';
import 'package:hostmi/widgets/app_bar/custom_app_bar.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_checkbox.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class AddNewPropertyReasonSellingHomeScreen extends StatelessWidget {
  bool isCheckbox = false;

  bool isCheckbox1 = false;

  bool isCheckbox2 = false;

  bool isCheckbox3 = false;

  bool isCheckbox4 = false;

  bool isCheckbox5 = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.gray50,
            appBar: CustomAppBar(
                height: getVerticalSize(48),
                leadingWidth: 64,
                leading: AppbarIconbutton1(
                    svgPath: ImageConstant.imgArrowleft,
                    margin: getMargin(left: 24),
                    onTap: () {
                      onTapArrowleft8(context);
                    }),
                centerTitle: true,
                title: AppbarSubtitle(text: "Add New Property")),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 24, top: 12, right: 24, bottom: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: getPadding(top: 20),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: getPadding(top: 8, bottom: 4),
                                    child: Text("Reason selling home",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeSemiBold14Gray900)),
                                CustomButton(
                                    height: getVerticalSize(33),
                                    width: getHorizontalSize(79),
                                    text: "04 / 08",
                                    fontStyle: ButtonFontStyle
                                        .ManropeSemiBold14WhiteA700_1)
                              ])),
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
                                      value: 0.5,
                                      backgroundColor: ColorConstant.blueGray50,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          ColorConstant.brown500))))),
                      Padding(
                          padding: getPadding(top: 26),
                          child: Text("Why are you selling your home?",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeBold18.copyWith(
                                  letterSpacing: getHorizontalSize(0.2)))),
                      CustomCheckbox(
                          width: getHorizontalSize(327),
                          text: "Upgrading my home",
                          iconSize: getHorizontalSize(20),
                          value: isCheckbox,
                          margin: getMargin(top: 13),
                          variant: CheckboxVariant.OutlineGray300,
                          shape: CheckboxShape.RoundedBorder8,
                          padding: CheckboxPadding.PaddingT14,
                          fontStyle: CheckboxFontStyle.ManropeSemiBold14Gray900,
                          onChange: (value) {
                            isCheckbox = value;
                          }),
                      CustomCheckbox(
                          width: getHorizontalSize(327),
                          text: "Selling secondary home",
                          iconSize: getHorizontalSize(20),
                          value: isCheckbox1,
                          margin: getMargin(top: 8),
                          variant: CheckboxVariant.OutlineGray300,
                          shape: CheckboxShape.RoundedBorder8,
                          padding: CheckboxPadding.PaddingT14,
                          fontStyle: CheckboxFontStyle.ManropeSemiBold14Gray900,
                          onChange: (value) {
                            isCheckbox1 = value;
                          }),
                      CustomCheckbox(
                          width: getHorizontalSize(327),
                          text: "Relocating",
                          iconSize: getHorizontalSize(20),
                          value: isCheckbox2,
                          margin: getMargin(top: 8),
                          variant: CheckboxVariant.OutlineGray300,
                          shape: CheckboxShape.RoundedBorder8,
                          padding: CheckboxPadding.PaddingT14,
                          fontStyle: CheckboxFontStyle.ManropeSemiBold14Gray900,
                          onChange: (value) {
                            isCheckbox2 = value;
                          }),
                      CustomCheckbox(
                          width: getHorizontalSize(327),
                          text: "Downsizing my home",
                          iconSize: getHorizontalSize(20),
                          value: isCheckbox3,
                          margin: getMargin(top: 8),
                          variant: CheckboxVariant.OutlineGray300,
                          shape: CheckboxShape.RoundedBorder8,
                          padding: CheckboxPadding.PaddingT14,
                          fontStyle: CheckboxFontStyle.ManropeSemiBold14Gray900,
                          onChange: (value) {
                            isCheckbox3 = value;
                          }),
                      CustomCheckbox(
                          width: getHorizontalSize(327),
                          text: "Retiring",
                          iconSize: getHorizontalSize(20),
                          value: isCheckbox4,
                          margin: getMargin(top: 8),
                          variant: CheckboxVariant.OutlineGray300,
                          shape: CheckboxShape.RoundedBorder8,
                          padding: CheckboxPadding.PaddingT14,
                          fontStyle: CheckboxFontStyle.ManropeSemiBold14Gray900,
                          onChange: (value) {
                            isCheckbox4 = value;
                          }),
                      Container(
                          width: double.maxFinite,
                          child: Container(
                              width: getHorizontalSize(327),
                              margin: getMargin(top: 8),
                              padding: getPadding(all: 16),
                              decoration: AppDecoration.outlineGray3002
                                  .copyWith(
                                      borderRadius:
                                          BorderRadiusStyle.roundedBorder10),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CustomCheckbox(
                                        text: "Other",
                                        iconSize: getHorizontalSize(20),
                                        value: isCheckbox5,
                                        fontStyle: CheckboxFontStyle
                                            .ManropeSemiBold14Gray900,
                                        onChange: (value) {
                                          isCheckbox5 = value;
                                        }),
                                    Padding(
                                        padding: getPadding(left: 28, top: 6),
                                        child: Text(
                                            "Please enter your reason for selling:",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtManrope12Gray900
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.4)))),
                                    Align(
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                            width: getHorizontalSize(263),
                                            margin: getMargin(
                                                left: 28, top: 10, right: 4),
                                            padding: getPadding(all: 12),
                                            decoration: AppDecoration
                                                .fillBluegray5087
                                                .copyWith(
                                                    borderRadius:
                                                        BorderRadiusStyle
                                                            .roundedBorder5),
                                            child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      width: getHorizontalSize(
                                                          210),
                                                      margin: getMargin(
                                                          top: 1, right: 28),
                                                      child: Text(
                                                          "E.g. I’m helping my parents sell their home.",
                                                          maxLines: null,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: AppStyle
                                                              .txtManrope12
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      getHorizontalSize(
                                                                          0.4))))
                                                ])))
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
    //Navigator.pushNamed(context, AppRoutes.addNewPropertyDecsriptionScreen);
  }

  onTapArrowleft8(BuildContext context) {
    Navigator.pop(context);
  }
}
