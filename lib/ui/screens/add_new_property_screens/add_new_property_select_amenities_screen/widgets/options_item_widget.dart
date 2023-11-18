import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/utils/app_color.dart';

class OptionsItemWidget extends StatelessWidget {
  const OptionsItemWidget({
    super.key,
    required this.amenity,
    required this.selected,
    this.onPressed,
  });

  final Map<dynamic, dynamic> amenity;
  final List<int> selected;
  final void Function()? onPressed;

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
        amenity["fr"],
        textAlign: TextAlign.left,
        style: TextStyle(
          color: selected.contains(amenity["id"])
              ? AppColor.grey
              : ColorConstant.gray900,
          fontSize: getFontSize(
            14,
          ),
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: selected.contains(amenity["id"]),
      backgroundColor: Colors.transparent,
      selectedColor: AppColor.primary,
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
      onPressed: onPressed,
    );
  }
}
