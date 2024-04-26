import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hostmi/theme/app_style.dart';
import 'package:hostmi/utils/app_color.dart';

showSelectedFilterDialog({
  required BuildContext context,
  required String title,
  required String subTitle,
  required Widget child,
  required void Function()? onValidate,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            AlertDialog(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  Text(subTitle, style: AppStyle.txtManrope12),
                ],
              ),
              content: Column(
                children: [
                  child,
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            foregroundColor: AppColor.black,
                          ),
                          child: const Text("Annuler"),
                          onPressed: () {
                            // Navigator.of(context).pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                        child: const Text("Valider"),
                        onPressed: () {
                          // Navigator.of(context).pop();
                          // onValidate!();
                        },
                      )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ).animate().moveY(begin: -16);
    },
  );
}
