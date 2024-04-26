import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';

// ignore: must_be_immutable
class ChipviewhomeItemWidget extends StatelessWidget {
  const ChipviewhomeItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RawChip(
      padding: getPadding(
        left: 20,
        right: 20,
      ),
      showCheckmark: false,
      labelPadding: EdgeInsets.zero,
      label: Text(
        "Home",
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
      backgroundColor: ColorConstant.gray50,
      selectedColor: ColorConstant.gray50,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: ColorConstant.blueGray400,
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
    );
  }
}
