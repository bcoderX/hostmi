import 'package:flutter/material.dart';
import 'package:hostmi/core/utils/image_constant.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/theme/app_style.dart';
import 'package:hostmi/ui/screens/product_details_screen/widgets/listrectangle4224_item_widget.dart';
import 'package:hostmi/widgets/custom_image_view.dart';

class AgencyReviews extends StatelessWidget {
  const AgencyReviews({super.key, required this.agencyId});
  final String agencyId;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: getPadding(left: 8, top: 14),
            child: Row(children: [
              Text("Note: 4.9",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtManropeBold32
                      .copyWith(letterSpacing: getHorizontalSize(0.2))),
              CustomImageView(
                  svgPath: ImageConstant.imgTicket,
                  height: getVerticalSize(15),
                  width: getHorizontalSize(96),
                  margin: getMargin(left: 12, top: 13, bottom: 14)),
              Padding(
                  padding: getPadding(left: 14, top: 15, bottom: 11),
                  child: Text("100 avis",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeMedium12Gray900
                          .copyWith(letterSpacing: getHorizontalSize(0.4))))
            ])),
        Padding(
            padding: getPadding(
              top: 21,
            ),
            child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: getVerticalSize(12));
                },
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Listrectangle4224ItemWidget();
                })),
      ],
    );
  }
}
