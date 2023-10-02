import 'package:flutter/services.dart';
import 'package:hostmi/utils/app_color.dart';

import '../faqs_get_help_screen/widgets/questions_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/app_bar/appbar_iconbutton_1.dart';
import 'package:hostmi/widgets/app_bar/appbar_subtitle.dart';
import 'package:hostmi/widgets/app_bar/custom_app_bar.dart';
import 'package:hostmi/widgets/custom_search_view.dart';

// ignore_for_file: must_be_immutable
class FaqsGetHelpScreen extends StatelessWidget {
  TextEditingController serchController = TextEditingController();

  FaqsGetHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.gray50,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("FAQs"),
          backgroundColor: AppColor.grey,
          foregroundColor: AppColor.black,
          elevation: 0.0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: Container(
            width: double.maxFinite,
            padding: getPadding(left: 24, top: 36, right: 24, bottom: 36),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomSearchView(
                      focusNode: FocusNode(),
                      controller: serchController,
                      hintText: "Search questions...",
                      padding: SearchViewPadding.PaddingT17,
                      prefix: Container(
                          margin: getMargin(
                              left: 16, top: 16, right: 12, bottom: 16),
                          child: CustomImageView(
                              svgPath: ImageConstant.imgSearch)),
                      prefixConstraints:
                          BoxConstraints(maxHeight: getVerticalSize(56)),
                      suffix: Padding(
                          padding:
                              EdgeInsets.only(right: getHorizontalSize(15)),
                          child: IconButton(
                              onPressed: () {
                                serchController.clear();
                              },
                              icon: Icon(Icons.clear,
                                  color: Colors.grey.shade600)))),
                  Padding(
                      padding: getPadding(top: 26),
                      child: Text("Frequently Asked",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtManropeBold18.copyWith(
                              letterSpacing: getHorizontalSize(0.2)))),
                  Padding(
                      padding: getPadding(top: 22),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return QuestionsItemWidget();
                          })),
                  Padding(
                      padding: getPadding(top: 23, bottom: 5),
                      child: Row(children: [
                        Text("Show all",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtManropeBold14Blue500.copyWith(
                                letterSpacing: getHorizontalSize(0.2))),
                        CustomImageView(
                            svgPath: ImageConstant.imgArrowright16x16,
                            height: getSize(16),
                            width: getSize(16),
                            margin: getMargin(left: 8, top: 1, bottom: 2))
                      ]))
                ])));
  }

  onTapArrowleft17(BuildContext context) {
    Navigator.pop(context);
  }
}
