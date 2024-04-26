import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/custom_button.dart';

class MyHomeEmptyScreen extends StatelessWidget {
  const MyHomeEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.gray50,
        body: Container(
          width: double.maxFinite,
          padding: getPadding(
            left: 25,
            right: 25,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                svgPath: ImageConstant.imgFrame,
                height: getSize(
                  255,
                ),
                width: getSize(
                  255,
                ),
                margin: getMargin(
                  top: 7,
                ),
              ),
              Padding(
                padding: getPadding(
                  top: 63,
                ),
                child: Text(
                  "Ready to sell your home?",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtManropeExtraBold20.copyWith(
                    letterSpacing: getHorizontalSize(
                      0.2,
                    ),
                  ),
                ),
              ),
              Container(
                width: getHorizontalSize(
                  324,
                ),
                margin: getMargin(
                  top: 6,
                ),
                child: Text(
                  "Relax is making it simpler to sell your home and move forward.",
                  maxLines: null,
                  textAlign: TextAlign.center,
                  style: AppStyle.txtManrope16.copyWith(
                    letterSpacing: getHorizontalSize(
                      0.3,
                    ),
                  ),
                ),
              ),
              CustomButton(
                height: getVerticalSize(
                  45,
                ),
                width: getHorizontalSize(
                  155,
                ),
                text: "Add property",
                margin: getMargin(
                  top: 25,
                ),
                shape: ButtonShape.RoundedBorder10,
                padding: ButtonPadding.PaddingAll13,
                fontStyle: ButtonFontStyle.ManropeBold14WhiteA700,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
