import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';

// ignore: must_be_immutable
class OptionsItemWidget extends StatelessWidget {
  OptionsItemWidget();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.transparent,
      ),
      child: RawChip(
        padding: getPadding(
          left: 20,
          right: 20,
        ),
        showCheckmark: false,
        labelPadding: EdgeInsets.zero,
        label: Text(
          "Free WiFi",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: ColorConstant.gray900,
            fontSize: getFontSize(
              14,
            ),
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: false,
        backgroundColor: Colors.transparent,
        selectedColor: ColorConstant.gray90033,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: ColorConstant.blueGray500,
            width: getHorizontalSize(
              1,
            ),
          ),
          borderRadius: BorderRadius.circular(
            getHorizontalSize(
              18,
            ),
          ),
        ),
        onSelected: (value) {},
      ),
    );
  }
}
