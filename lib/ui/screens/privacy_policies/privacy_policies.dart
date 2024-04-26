import 'package:hostmi/api/constants/privacy.dart';
import 'package:hostmi/api/models/faq_model.dart';
import 'package:hostmi/utils/app_color.dart';
import '../faqs_get_help_screen/widgets/questions_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';

// ignore_for_file: must_be_immutable
class PrivacyPocilcyScreen extends StatelessWidget {
  TextEditingController serchController = TextEditingController();
  List<FaqModel> privacyItems = privacyPolicies;
  PrivacyPocilcyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.grey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Politique de confidentialité"),
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
                      ...privacyItems
                          .map((e) => QuestionsItemWidget(faq: e))
                          .toList(),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text("Fait à Koudougou le 05 Mai 2023.")
                    ])),
          ),
        ));
  }

  onTapArrowleft17(BuildContext context) {
    Navigator.pop(context);
  }
}
