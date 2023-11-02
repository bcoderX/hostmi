import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/custom_drop_down.dart';

// ignore: must_be_immutable
class AppbarDropdown extends StatelessWidget {
  AppbarDropdown(
      {super.key,
      required this.hintText,
      required this.items,
      required this.onTap,
      this.margin});

  String? hintText;

  List<String> items;

  Function(String) onTap;

  EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: CustomDropDown<String>(
        width: getHorizontalSize(
          149,
        ),
        focusNode: FocusNode(),
        icon: Container(
          margin: getMargin(
            left: 4,
          ),
          child: CustomImageView(
            svgPath: ImageConstant.imgArrowdown,
          ),
        ),
        hintText: "St. Celina, Delaware",
        variant: DropDownVariant.None,
        fontStyle: DropDownFontStyle.ManropeSemiBold14Gray900,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) {
          onTap(value);
        },
      ),
    );
  }
}
