import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/ui/widgets/rounded_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/utils/app_text_size.dart';

import '../../../api/constants/roles.dart';

class ChoicePage extends StatefulWidget {
  const ChoicePage({Key? key, required this.next}) : super(key: key);
  final String next;

  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  final SizedBox _spacer = const SizedBox(height: 20);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(children: [
                Text(
                  "Comment voulez-vous utiliser l'application ?",
                  style:
                      TextStyle(fontSize: getFontSize(30), color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                _spacer,
              ]),
            ),
            _spacer,
            Image.asset(
              "assets/images/question_mark.png",
              fit: BoxFit.fitWidth,
            ),
            _spacer,
            SizedBox(
              width: double.infinity,
              child: RoundedButton(
                buttonColor: AppColor.primary,
                fontSize: AppTextSize.heading16,
                text: "Je cherche une maison",
                textColor: AppColor.white,
                onTap: () {
                  setRole(Role.TENANT);
                  if (widget.next.isEmpty) {
                    context.go("/list");
                  } else {
                    context.go("/${widget.next}");
                  }
                },
              ),
            ),
            _spacer,
            SizedBox(
              width: double.infinity,
              child: RoundedButton(
                buttonColor: Colors.white,
                fontSize: AppTextSize.heading16,
                text: "Je suis promoteur immobilier",
                textColor: AppColor.primary,
                borderColor: AppColor.primary,
                onTap: () {
                  setRole(Role.DEVELOPER);
                  if (widget.next.isNotEmpty) {
                    context.push("/${widget.next}");
                  } else {
                    context.go("/publish");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
