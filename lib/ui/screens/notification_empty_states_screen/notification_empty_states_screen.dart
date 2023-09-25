import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/app_bar/appbar_iconbutton_1.dart';
import 'package:hostmi/widgets/app_bar/appbar_subtitle.dart';
import 'package:hostmi/widgets/app_bar/custom_app_bar.dart';
import 'package:hostmi/widgets/custom_button.dart';

class NotificationEmptyStatesScreen extends StatelessWidget {
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
                      onTapArrowleft1(context);
                    }),
                centerTitle: true,
                title: AppbarSubtitle(text: "Notification")),
            body: Container(
                width: double.maxFinite,
                padding: getPadding(left: 41, top: 108, right: 41),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomImageView(
                          svgPath: ImageConstant.imgMailnotification,
                          height: getVerticalSize(204),
                          width: getHorizontalSize(255)),
                      Padding(
                          padding: getPadding(top: 31),
                          child: Text("No Notifications Yet",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeExtraBold20.copyWith(
                                  letterSpacing: getHorizontalSize(0.2)))),
                      Container(
                          width: getHorizontalSize(292),
                          margin: getMargin(top: 9),
                          child: Text(
                              "No notification right now, notifications about your activity will show up here.",
                              maxLines: null,
                              textAlign: TextAlign.center,
                              style: AppStyle.txtManrope16.copyWith(
                                  letterSpacing: getHorizontalSize(0.3)))),
                      CustomButton(
                          height: getVerticalSize(45),
                          text: "Notifications Settings",
                          margin: getMargin(
                              left: 36, top: 21, right: 37, bottom: 5),
                          shape: ButtonShape.RoundedBorder10,
                          padding: ButtonPadding.PaddingAll13,
                          fontStyle: ButtonFontStyle.ManropeBold14WhiteA700,
                          onTap: () {
                            onTapNotificationssettings(context);
                          })
                    ]))));
  }

  onTapNotificationssettings(BuildContext context) {
    //Navigator.pushNamed(context, AppRoutes.notificationScreen);
  }

  onTapArrowleft1(BuildContext context) {
    Navigator.pop(context);
  }
}
