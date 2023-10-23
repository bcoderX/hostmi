import 'package:flutter/material.dart';
import 'package:hostmi/utils/app_color.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.icon,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
  }) : super(key: key);
  final Widget? icon;
  final String text;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0.0,
          padding: padding,
          backgroundColor: backgroundColor ?? Colors.grey[300],
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            icon ?? const SizedBox(),
            Text(
              text,
              style: TextStyle(color: foregroundColor ?? AppColor.black),
            ),
          ],
        ),
      ),
    );
  }
}
