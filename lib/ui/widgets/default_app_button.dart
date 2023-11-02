import 'package:flutter/material.dart';
import 'package:hostmi/utils/app_color.dart';

class DefaultAppButton extends StatelessWidget {
  const DefaultAppButton(
      {super.key,
      this.onPressed,
      required this.text,
      this.color,
      this.textColor});
  final void Function()? onPressed;
  final String text;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? AppColor.primary,
      borderRadius: BorderRadius.circular(5.0),
      child: MaterialButton(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          minWidth: double.infinity,
          onPressed: onPressed,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor ?? AppColor.grey,
            ),
          )),
    );
  }
}
