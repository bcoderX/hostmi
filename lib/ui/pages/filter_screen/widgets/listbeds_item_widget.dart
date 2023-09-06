import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';

// ignore: must_be_immutable
class ListbedsItemWidget extends StatelessWidget {
  ListbedsItemWidget();

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
              "",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtManropeMedium16.copyWith(
                letterSpacing: getHorizontalSize(
                  0.2,
                ),
              ),
            ),
          ),
          Spacer(),
          CustomImageView(
            svgPath: ImageConstant.imgClock24x24,
            height: getSize(
              24,
            ),
            width: getSize(
              24,
            ),
          ),
          Padding(
            padding: getPadding(
              left: 15,
              top: 1,
            ),
            child: Text(
              "",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: AppStyle.txtManropeExtraBold16Gray900.copyWith(
                letterSpacing: getHorizontalSize(
                  0.2,
                ),
              ),
            ),
          ),
          CustomImageView(
            svgPath: ImageConstant.imgPlus1,
            height: getSize(
              24,
            ),
            width: getSize(
              24,
            ),
            margin: getMargin(
              left: 15,
            ),
          ),
        ],
      ),
    );
  }
}
