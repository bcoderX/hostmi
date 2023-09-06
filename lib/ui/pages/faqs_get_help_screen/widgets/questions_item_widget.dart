import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';

// ignore: must_be_immutable
class QuestionsItemWidget extends StatelessWidget {
  QuestionsItemWidget();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtManropeBold14.copyWith(
                    letterSpacing: getHorizontalSize(
                      0.2,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: getHorizontalSize(
                325,
              ),
              margin: getMargin(
                top: 13,
              ),
              child: Text(
                "",
                maxLines: null,
                textAlign: TextAlign.left,
                style: AppStyle.txtManrope12Gray900.copyWith(
                  letterSpacing: getHorizontalSize(
                    0.4,
                  ),
                ),
              ),
            ),
          ],
        ),
        trailing: CustomImageView(
          svgPath: ImageConstant.imgArrowupBlueGray500,
          height: getSize(
            20,
          ),
          width: getSize(
            20,
          ),
        ),
        children: [
          Padding(
            padding: getPadding(
              top: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Divider(
                  height: getVerticalSize(
                    1,
                  ),
                  thickness: getVerticalSize(
                    1,
                  ),
                  color: ColorConstant.gray300,
                ),
              ],
            ),
          ),
        ],
        onExpansionChanged: (value) {},
      ),
    );
  }
}
