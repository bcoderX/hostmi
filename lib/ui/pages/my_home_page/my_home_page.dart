import '../my_home_page/widgets/my_home_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/app_bar/appbar_iconbutton_1.dart';
import 'package:hostmi/widgets/app_bar/appbar_subtitle.dart';
import 'package:hostmi/widgets/app_bar/custom_app_bar.dart';
import 'package:hostmi/widgets/custom_button.dart';

class MyHomePage extends StatelessWidget {
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
                      onTapArrowleft4(context);
                    }),
                centerTitle: true,
                title: AppbarSubtitle(text: "My Home")),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 24, top: 32, right: 24, bottom: 32),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: getVerticalSize(16));
                          },
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return MyHomeItemWidget(onTapProperty: () {
                              onTapProperty(context);
                            });
                          }),
                      CustomButton(
                          height: getVerticalSize(56),
                          text: "Add New Property",
                          margin: getMargin(top: 24, bottom: 5),
                          variant: ButtonVariant.OutlineBlue500_1,
                          shape: ButtonShape.RoundedBorder10,
                          padding: ButtonPadding.PaddingT17,
                          fontStyle: ButtonFontStyle.ManropeBold14Blue500_1,
                          prefixWidget: Container(
                              margin: getMargin(right: 10),
                              child: CustomImageView(
                                  svgPath: ImageConstant.imgPlus24x24)),
                          onTap: () {
                            onTapAddnewproperty(context);
                          })
                    ]))));
  }

  onTapProperty(BuildContext context) {
    //Navigator.pushNamed(context, AppRoutes.productDetailsScreen);
  }

  onTapAddnewproperty(BuildContext context) {
    //Navigator.pushNamed(context, AppRoutes.addNewPropertyAddressScreen);
  }

  onTapArrowleft4(BuildContext context) {
    Navigator.pop(context);
  }
}
