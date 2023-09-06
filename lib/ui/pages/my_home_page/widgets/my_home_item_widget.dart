import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';

// ignore: must_be_immutable
class MyHomeItemWidget extends StatelessWidget {
  MyHomeItemWidget({this.onTapProperty});

  VoidCallback? onTapProperty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapProperty?.call();
      },
      child: Container(
        decoration: AppDecoration.outlineGray3001.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: Row(
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgImage109x102,
              height: getVerticalSize(
                109,
              ),
              width: getHorizontalSize(
                102,
              ),
              radius: BorderRadius.only(
                topLeft: Radius.circular(
                  getHorizontalSize(
                    10,
                  ),
                ),
                bottomLeft: Radius.circular(
                  getHorizontalSize(
                    10,
                  ),
                ),
              ),
            ),
            Padding(
              padding: getPadding(
                left: 16,
                top: 15,
                bottom: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Primary Apartment",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtManropeBold16.copyWith(
                      letterSpacing: getHorizontalSize(
                        0.2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: getPadding(
                      top: 7,
                    ),
                    child: Row(
                      children: [
                        CustomImageView(
                          svgPath: ImageConstant.imgLock,
                          height: getSize(
                            16,
                          ),
                          width: getSize(
                            16,
                          ),
                          margin: getMargin(
                            top: 1,
                            bottom: 3,
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            left: 4,
                          ),
                          child: Text(
                            "3",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtManropeMedium14Bluegray500,
                          ),
                        ),
                        CustomImageView(
                          svgPath: ImageConstant.imgPrinter,
                          height: getSize(
                            16,
                          ),
                          width: getSize(
                            16,
                          ),
                          margin: getMargin(
                            left: 12,
                            top: 1,
                            bottom: 3,
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            left: 4,
                          ),
                          child: Text(
                            "2",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtManropeMedium14Bluegray500,
                          ),
                        ),
                        CustomImageView(
                          svgPath: ImageConstant.imgOffer,
                          height: getSize(
                            16,
                          ),
                          width: getSize(
                            16,
                          ),
                          margin: getMargin(
                            left: 12,
                            top: 1,
                            bottom: 3,
                          ),
                        ),
                        Padding(
                          padding: getPadding(
                            left: 4,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "1,880",
                                  style: TextStyle(
                                    color: ColorConstant.blueGray500,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: " ",
                                  style: TextStyle(
                                    color: ColorConstant.blueGray500,
                                    fontSize: getFontSize(
                                      14,
                                    ),
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: getHorizontalSize(
                                      0.2,
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: "Ft",
                                  style: TextStyle(
                                    color: ColorConstant.blueGray500,
                                    fontSize: getFontSize(
                                      10,
                                    ),
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: getHorizontalSize(
                                      0.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: getPadding(
                      top: 8,
                    ),
                    child: Text(
                      "1,600 - 1,800 ",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeExtraBold16.copyWith(
                        letterSpacing: getHorizontalSize(
                          0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
