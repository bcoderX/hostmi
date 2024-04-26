import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/custom_icon_button.dart';

// ignore: must_be_immutable
class ListimgItemWidget extends StatelessWidget {
  const ListimgItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getVerticalSize(
        418,
      ),
      width: getHorizontalSize(
        327,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgImg418x3271,
            height: getVerticalSize(
              418,
            ),
            width: getHorizontalSize(
              327,
            ),
            radius: BorderRadius.circular(
              getHorizontalSize(
                10,
              ),
            ),
            alignment: Alignment.center,
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: getPadding(
                left: 16,
                right: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomIconButton(
                    height: 36,
                    width: 36,
                    variant: IconButtonVariant.OutlineBluegray50_1,
                    child: CustomImageView(
                      svgPath: ImageConstant.imgClock,
                    ),
                  ),
                  Container(
                    margin: getMargin(
                      top: 268,
                    ),
                    padding: getPadding(
                      top: 14,
                      bottom: 14,
                    ),
                    decoration: AppDecoration.fillGray50.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: getPadding(
                            top: 3,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Mighty Cinco Family",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeExtraBold18.copyWith(
                                  letterSpacing: getHorizontalSize(
                                    0.2,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: getPadding(
                                  top: 6,
                                ),
                                child: Row(
                                  children: [
                                    CustomImageView(
                                      svgPath: ImageConstant.imgLocation,
                                      height: getSize(
                                        14,
                                      ),
                                      width: getSize(
                                        14,
                                      ),
                                      margin: getMargin(
                                        bottom: 2,
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(
                                        left: 4,
                                      ),
                                      child: Text(
                                        "Jakarta, Indonesia",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtManrope12Gray900
                                            .copyWith(
                                          letterSpacing: getHorizontalSize(
                                            0.4,
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
                        Padding(
                          padding: getPadding(
                            top: 1,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "436",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeExtraBold18Blue500
                                    .copyWith(
                                  letterSpacing: getHorizontalSize(
                                    0.2,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: getPadding(
                                  top: 9,
                                ),
                                child: Text(
                                  "per month",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtManrope12.copyWith(
                                    letterSpacing: getHorizontalSize(
                                      0.4,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
