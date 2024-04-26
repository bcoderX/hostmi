import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hostmi/theme/app_style.dart';
import 'package:hostmi/ui/widgets/hostmi_review_dialog_widget.dart';

showHostmiRatingDialog(BuildContext context) {
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
                  const Text("Avis et suggestions"),
                  Text("Aider nous à mieux vous servir",
                      style: AppStyle.txtManrope12),
                ],
              ),
              content: const HostmiReviewDialogWidget(),
            ),
          ],
        ),
      ).animate().moveX(begin: 16);
    },
  );
}
