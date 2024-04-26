import '../notification_screen/widgets/listchartline_item_widget.dart';
import '../notification_screen/widgets/listhome_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/app_bar/appbar_iconbutton_1.dart';
import 'package:hostmi/widgets/app_bar/appbar_subtitle.dart';
import 'package:hostmi/widgets/app_bar/custom_app_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
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
                onTapArrowleft(context);
              },
            ),
            centerTitle: true,
            title: AppbarSubtitle(text: "Notification")),
        body: Container(
          width: double.maxFinite,
          padding: getPadding(left: 24, top: 35, right: 24, bottom: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Today",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtManropeBold16
                      .copyWith(letterSpacing: getHorizontalSize(0.2))),
              Padding(
                  padding: getPadding(top: 15),
                  child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: getVerticalSize(14));
                      },
                      itemCount: 2,
                      itemBuilder: (context, index) {
                        return const ListhomeItemWidget();
                      })),
              Padding(
                  padding: getPadding(top: 22),
                  child: Text("This Week",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeBold16
                          .copyWith(letterSpacing: getHorizontalSize(0.2)))),
              Padding(
                padding: getPadding(top: 17),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: getVerticalSize(14));
                  },
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return const ListchartlineItemWidget();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onTapArrowleft(BuildContext context) {
    Navigator.pop(context);
  }
}
