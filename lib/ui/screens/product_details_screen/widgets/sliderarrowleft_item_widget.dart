import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/custom_icon_button.dart';

// ignore: must_be_immutable
class SliderarrowleftItemWidget extends StatelessWidget {
  const SliderarrowleftItemWidget({super.key, required this.imageUrl});
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: getSize(
          343,
        ),
        width: double.infinity,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              height: getSize(343),
              width: double.infinity,
              alignment: Alignment.center,
              fit: BoxFit.cover,
            ),
            // CustomImageView(
            //   imagePath: ImageConstant.imgImage343x3431,
            //   height: getSize(
            //     343,
            //   ),
            //   width: double.infinity,
            //   alignment: Alignment.center,
            // ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: getPadding(
                  left: 24,
                  top: 24,
                  right: 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: getPadding(
                        bottom: 1,
                      ),
                      child: Text(
                        "Primary Apartment",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeExtraBold24WhiteA700,
                      ),
                    ),
                    Padding(
                      padding: getPadding(
                        bottom: 30,
                      ),
                      child: Text(
                        "701 Ocean Avenue, Unit 103, Santa Monica",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeMedium14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
