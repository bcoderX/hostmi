import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/app_bar/appbar_iconbutton_1.dart';
import 'package:hostmi/widgets/app_bar/appbar_subtitle.dart';
import 'package:hostmi/widgets/app_bar/custom_app_bar.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';

class AddNewPropertyAddressScreen extends StatelessWidget {
  TextEditingController propertyaddressTwoController = TextEditingController();

  TextEditingController unitnumberController = TextEditingController();

  TextEditingController citynameController = TextEditingController();

  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];

  TextEditingController zipcodeController = TextEditingController();

  AddNewPropertyAddressScreen({super.key});

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
                      onTapArrowleft5(context);
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
                                padding: getPadding(top: 7, bottom: 5),
                                child: Text("Address",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppStyle.txtManropeSemiBold14Gray900)),
                            CustomButton(
                                height: getVerticalSize(33),
                                width: getHorizontalSize(76),
                                text: "01 / 08",
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
                                      value: 0.12,
                                      backgroundColor: ColorConstant.blueGray50,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          ColorConstant.brown500))))),
                      Padding(
                          padding: getPadding(top: 26),
                          child: Text("Property Address",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeBold18.copyWith(
                                  letterSpacing: getHorizontalSize(0.2)))),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: propertyaddressTwoController,
                          hintText: "Street address",
                          margin: getMargin(top: 13)),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: unitnumberController,
                          hintText: "Unit number",
                          margin: getMargin(top: 12),
                          textInputType: TextInputType.number),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: citynameController,
                          hintText: "City name",
                          margin: getMargin(top: 12)),
                      // CustomDropDown(
                      //     focusNode: FocusNode(),
                      //     icon: Container(
                      //         margin: getMargin(left: 30, right: 16),
                      //         child: CustomImageView(
                      //             svgPath: ImageConstant.imgArrowdownGray900)),
                      //     hintText: "Select state",
                      //     margin: getMargin(top: 12),
                      //     variant: DropDownVariant.FillBluegray50,
                      //     fontStyle:
                      //         DropDownFontStyle.ManropeMedium14Bluegray500,
                      //     items: dropdownItemList,
                      //     onChanged: (value) {}),
                      CustomTextFormField(
                          focusNode: FocusNode(),
                          controller: zipcodeController,
                          hintText: "Zip code",
                          margin: getMargin(top: 12, bottom: 5),
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.number)
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
    //Navigator.pushNamed(context, AppRoutes.addNewPropertyMeetWithAAgentScreen);
  }

  onTapArrowleft5(BuildContext context) {
    Navigator.pop(context);
  }
}
