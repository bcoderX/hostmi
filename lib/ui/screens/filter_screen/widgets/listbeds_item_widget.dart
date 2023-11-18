import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/utils/app_color.dart';

// ignore: must_be_immutable
class ListbedsItemWidget extends StatelessWidget {
  ListbedsItemWidget(
      {super.key,
      required this.label,
      required this.value,
      this.onDecrease,
      this.onIncrease});
  final String label;
  final int value;
  void Function()? onIncrease;
  void Function()? onDecrease;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: getPadding(
              top: 1,
            ),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtManropeMedium16.copyWith(
                letterSpacing: getHorizontalSize(
                  0.2,
                ),
              ),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onDecrease,
            child: Icon(
              Icons.remove_circle,
              color: AppColor.placeholderGrey,
              size: getSize(30),
            ),
          ),
          Padding(
            padding: getPadding(
              left: 15,
              top: 1,
              right: 15,
            ),
            child: Text(
              "$value",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtManropeExtraBold16Gray900.copyWith(
                letterSpacing: getHorizontalSize(
                  0.2,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onIncrease,
            child: Icon(
              Icons.add_circle,
              color: AppColor.primary,
              size: getSize(30),
            ),
          ),
        ],
      ),
    );
  }
}
