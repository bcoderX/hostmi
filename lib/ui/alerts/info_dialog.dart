import 'package:flutter/material.dart';
import 'package:hostmi/utils/app_color.dart';

showInfoDialog({
  required String title,
  required String content,
  String actionTitle = "OK",
  String ignoreTitle = "Ignorer",
  required BuildContext context,
  required void Function()? onClick,
  void Function()? onIgnoreClick,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        icon: const Icon(Icons.error),
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              content,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onClick != null) {
                    onClick();
                  }
                },
                child: Text(actionTitle),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.grey,
                    foregroundColor: AppColor.black),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onIgnoreClick != null) {
                    onIgnoreClick();
                  }
                },
                child: Text(ignoreTitle),
              ),
            ),
          ],
        ),
      );
    },
  );
}
