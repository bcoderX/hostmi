import 'package:flutter/material.dart';
import 'package:hostmi/api/models/faq_model.dart';
import 'package:hostmi/core/app_export.dart';

// ignore: must_be_immutable
class QuestionsItemWidget extends StatelessWidget {
  const QuestionsItemWidget({super.key, required this.faq});
  final FaqModel faq;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        tilePadding: EdgeInsets.zero,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              faq.question,
              textAlign: TextAlign.left,
              style: AppStyle.txtManropeBold14.copyWith(
                letterSpacing: getHorizontalSize(
                  0.2,
                ),
              ),
            ),
            faq.description.isNotEmpty
                ? Container(
                    width: getHorizontalSize(
                      325,
                    ),
                    margin: getMargin(
                      top: 13,
                    ),
                    child: Text(
                      faq.description,
                      maxLines: null,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManrope12Gray900.copyWith(
                        letterSpacing: getHorizontalSize(
                          0.4,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
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
          Text(
            faq.answer,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(
            height: 5,
          ),
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
        onExpansionChanged: (value) {},
      ),
    );
  }
}
