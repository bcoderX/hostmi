import 'package:hostmi/api/constants/faqs.dart';
import 'package:hostmi/api/models/faq_model.dart';
import 'package:hostmi/utils/app_color.dart';

import '../faqs_get_help_screen/widgets/questions_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';

// ignore_for_file: must_be_immutable
class FaqsGetHelpScreen extends StatelessWidget {
  TextEditingController serchController = TextEditingController();
  List<FaqModel> faqItems = faqList;
  FaqsGetHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.grey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Aide et assistance"),
          backgroundColor: AppColor.grey,
          foregroundColor: AppColor.black,
          elevation: 0.0,
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Container(
                width: double.maxFinite,
                padding: getPadding(left: 24, top: 36, right: 24, bottom: 36),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // CustomSearchView(
                      //     focusNode: FocusNode(),
                      //     controller: serchController,
                      //     hintText: "Chercher des questions...",
                      //     padding: SearchViewPadding.PaddingT17,
                      //     prefix: Container(
                      //         margin: getMargin(
                      //             left: 16, top: 16, right: 12, bottom: 16),
                      //         child: CustomImageView(
                      //             svgPath: ImageConstant.imgSearch)),
                      //     prefixConstraints:
                      //         BoxConstraints(maxHeight: getVerticalSize(56)),
                      //     suffix: Padding(
                      //         padding:
                      //             EdgeInsets.only(right: getHorizontalSize(15)),
                      //         child: IconButton(
                      //             onPressed: () {
                      //               serchController.clear();
                      //             },
                      //             icon: Icon(Icons.clear,
                      //                 color: Colors.grey.shade600)))),
                      Padding(
                        padding: getPadding(top: 5),
                        child: Text(
                          "Questions fréquemment posées",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtManropeBold18.copyWith(
                            letterSpacing: getHorizontalSize(0.2),
                          ),
                        ),
                      ),
                      ...faqItems
                          .map((e) => QuestionsItemWidget(faq: e))
                          .toList(),
                    ])),
          ),
        ));
  }

  onTapArrowleft17(BuildContext context) {
    Navigator.pop(context);
  }
}
