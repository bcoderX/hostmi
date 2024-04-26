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
    this.margin = const EdgeInsets.symmetric(horizontal: 5.0),
  }) : super(key: key);
  final Widget? icon;
  final String text;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColor.white,
          border: backgroundColor == null
              ? Border.all(color: Colors.grey[300]!)
              : null,
          borderRadius: BorderRadius.circular(10.0),
        ),
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
