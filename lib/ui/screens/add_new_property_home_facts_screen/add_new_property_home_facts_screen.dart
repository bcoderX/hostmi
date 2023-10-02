import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/app_bar/appbar_iconbutton_1.dart';
import 'package:hostmi/widgets/app_bar/appbar_subtitle.dart';
import 'package:hostmi/widgets/app_bar/custom_app_bar.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_drop_down.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class AddNewPropertyHomeFactsScreen extends StatelessWidget {
  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];

  TextEditingController inputController = TextEditingController();

  TextEditingController inputOneController = TextEditingController();

  TextEditingController inputTwoController = TextEditingController();

  TextEditingController inputThreeController = TextEditingController();

  TextEditingController inputFourController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController priceOneController = TextEditingController();

  AddNewPropertyHomeFactsScreen({super.key});

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
                      onTapArrowleft10(context);
                    }),
                centerTitle: true,
                title: AppbarSubtitle(text: "Add New Property")),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 23, top: 32, right: 23, bottom: 32),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: getPadding(left: 1, right: 1),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: getPadding(top: 6, bottom: 6),
                                    child: Text("Home facts",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeSemiBold14Gray900)),
                                CustomButton(
                                    height: getVerticalSize(33),
                                    width: getHorizontalSize(79),
                                    text: "06 / 08",
                                    fontStyle: ButtonFontStyle
                                        .ManropeSemiBold14WhiteA700_1)
                              ])),
                      Padding(
                          padding: getPadding(left: 1, top: 16),
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
                                          ColorConstant.brown500))))),
                      Padding(
                          padding: getPadding(left: 1, top: 24),
                          child: Text("Home facts",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeBold18.copyWith(
                                  letterSpacing: getHorizontalSize(0.2)))),
                      Container(
                          width: getHorizontalSize(321),
                          margin: getMargin(left: 1, top: 9, right: 6),
                          child: Text(
                              "This helps your agent prepare the most accurate home estimate",
                              maxLines: null,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManrope12.copyWith(
                                  letterSpacing: getHorizontalSize(0.4)))),
                      Padding(
                          padding: getPadding(left: 1, top: 19),
                          child: Text("Type Property",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeMedium12Bluegray500
                                  .copyWith(
                                      letterSpacing: getHorizontalSize(0.4)))),
                      // CustomDropDown(
                      //     focusNode: FocusNode(),
                      //     icon: Container(
                      //         margin: getMargin(left: 30, right: 16),
                      //         child: CustomImageView(
                      //             svgPath: ImageConstant.imgArrowdownGray900)),
                      //     hintText: "Select type",
                      //     margin: getMargin(left: 1, top: 6),
                      //     variant: DropDownVariant.FillBluegray50,
                      //     fontStyle:
                      //         DropDownFontStyle.ManropeMedium14Bluegray500,
                      //     items: dropdownItemList,
                      //     onChanged: (value) {}),
                      Padding(
                          padding: getPadding(left: 1, top: 13, right: 1),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding: getPadding(top: 1),
                                                child: Text("Finished Sq. Ft.",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeMedium12Bluegray500
                                                        .copyWith(
                                                            letterSpacing:
                                                                getHorizontalSize(
                                                                    0.4)))),
                                            CustomImageView(
                                                svgPath:
                                                    ImageConstant.imgWarning,
                                                height: getSize(16),
                                                width: getSize(16),
                                                margin: getMargin(
                                                    left: 51, bottom: 2))
                                          ]),
                                      CustomTextFormField(
                                          width: getHorizontalSize(158),
                                          focusNode: FocusNode(),
                                          controller: inputController,
                                          hintText: "0",
                                          margin: getMargin(top: 6))
                                    ]),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Lot Size",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtManropeMedium12Bluegray500
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.4))),
                                      CustomTextFormField(
                                          width: getHorizontalSize(157),
                                          focusNode: FocusNode(),
                                          controller: inputOneController,
                                          hintText: "0",
                                          margin: getMargin(top: 7))
                                    ])
                              ])),
                      Padding(
                          padding: getPadding(left: 1, top: 17, right: 1),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Year Built",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeMedium12Bluegray500
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.4))),
                                    CustomTextFormField(
                                      width: getHorizontalSize(158),
                                      focusNode: FocusNode(),
                                      controller: inputTwoController,
                                      hintText: "0",
                                      margin: getMargin(top: 7),
                                    ),
                                  ],
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Bedrooms",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtManropeMedium12Bluegray500
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.4))),
                                      CustomTextFormField(
                                          width: getHorizontalSize(157),
                                          focusNode: FocusNode(),
                                          controller: inputThreeController,
                                          hintText: "0",
                                          margin: getMargin(top: 7))
                                    ])
                              ])),
                      Padding(
                          padding: getPadding(left: 1, top: 17),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Padding(
                                        padding: getPadding(right: 6),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text("Full Baths",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: AppStyle
                                                            .txtManropeMedium12Bluegray500
                                                            .copyWith(
                                                                letterSpacing:
                                                                    getHorizontalSize(
                                                                        0.4))),
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgWarning,
                                                        height: getSize(16),
                                                        width: getSize(16),
                                                        margin: getMargin(
                                                            left: 83,
                                                            bottom: 1))
                                                  ]),
                                              CustomTextFormField(
                                                  width: getHorizontalSize(158),
                                                  focusNode: FocusNode(),
                                                  controller:
                                                      inputFourController,
                                                  hintText: "0",
                                                  margin: getMargin(top: 7))
                                            ]))),
                                Expanded(
                                    child: Padding(
                                        padding: getPadding(left: 6),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            getPadding(top: 1),
                                                        child: Text(
                                                            "Security Deposit",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: AppStyle
                                                                .txtManropeMedium12Bluegray500
                                                                .copyWith(
                                                                    letterSpacing:
                                                                        getHorizontalSize(
                                                                            0.4)))),
                                                    CustomImageView(
                                                        svgPath: ImageConstant
                                                            .imgWarning,
                                                        height: getSize(16),
                                                        width: getSize(16),
                                                        margin: getMargin(
                                                            left: 42,
                                                            bottom: 2))
                                                  ]),
                                              CustomTextFormField(
                                                  width: getHorizontalSize(158),
                                                  focusNode: FocusNode(),
                                                  controller: priceController,
                                                  hintText: "0 ",
                                                  margin: getMargin(top: 6))
                                            ])))
                              ])),
                      Padding(
                          padding: getPadding(left: 1, top: 18),
                          child: Text("Monthly Rent*",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeMedium12Bluegray500
                                  .copyWith(
                                      letterSpacing: getHorizontalSize(0.4)))),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: priceOneController,
                          hintText: "0 ",
                          margin: getMargin(left: 1, top: 6),
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
    //Navigator.pushNamed(context, AppRoutes.addNewPropertyContactScreen);
  }

  onTapArrowleft10(BuildContext context) {
    Navigator.pop(context);
  }
}
