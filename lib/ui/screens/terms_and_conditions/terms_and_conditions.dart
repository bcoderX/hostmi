import 'package:hostmi/api/constants/terms_and_conditions_data.dart';
import 'package:hostmi/api/models/faq_model.dart';
import 'package:hostmi/utils/app_color.dart';
import '../faqs_get_help_screen/widgets/questions_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';

// ignore_for_file: must_be_immutable
class TermsAndConditionsScreen extends StatelessWidget {
  TextEditingController serchController = TextEditingController();
  List<FaqModel> privacyItems = termsAndConditions;
  TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.grey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Conditions d'utilisations"),
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
                      Padding(
                        padding: getPadding(top: 5),
                        child: Text(
                          "CONDITIONS GENERALES D’UTILISATION DE HostMI",
                          textAlign: TextAlign.left,
                          style: AppStyle.txtManropeBold18.copyWith(
                            letterSpacing: getHorizontalSize(0.2),
                          ),
                        ),
                      ),
                      const Text(
                        "Nous vous remercions d'avoir choisi HostMI. En utilisant cette application, vous acceptez les conditions générales suivantes. Veuillez lire attentivement ces conditions avant d'utiliser l'application.",
                        textAlign: TextAlign.justify,
                      ),
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
