import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/utils/app_color.dart';

class SearchDropdownButton extends StatelessWidget {
  const SearchDropdownButton({
    Key? key,
    this.icon,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.subtileText,
  }) : super(key: key);
  final Widget? icon;
  final String text;
  final String? subtileText;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        padding: padding ??
            getPadding(
              left: 12,
              top: 6,
              right: 12,
              bottom: 6,
            ),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColor.primary,
          border: backgroundColor == null
              ? Border.all(color: Colors.grey[200]!)
              : null,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
                    text: text,
                    style: TextStyle(color: foregroundColor ?? AppColor.white),
                    children: subtileText == null
                        ? null
                        : [
                            TextSpan(
                                text: "\n$subtileText",
                                style: const TextStyle(
                                  fontSize: 9,
                                ))
                          ])),
            icon ??
                Icon(
                  Icons.arrow_drop_down,
                  color: foregroundColor ?? Colors.white,
                ),
          ],
        ),
      ),
    );
  }
}
