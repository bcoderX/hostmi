import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hostmi/api/models/review_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/app_export.dart';

// ignore: must_be_immutable
class Listrectangle4224ItemWidget extends StatelessWidget {
  const Listrectangle4224ItemWidget({super.key, required this.review});
  final ReviewModel review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(
        all: 12,
      ),
      decoration: AppDecoration.outlineGray3002.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Row(
        children: [
          CustomImageView(
            url: review.avatarUrl == null
                ? null
                : supabase.storage
                    .from("profiles")
                    .getPublicUrl(review.avatarUrl!),
            height: getSize(
              62,
            ),
            width: getSize(
              62,
            ),
            radius: BorderRadius.circular(
              getHorizontalSize(
                5,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: getPadding(
                left: 12,
                top: 2,
                bottom: 1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    review.fullName,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtManropeBold12.copyWith(
                      letterSpacing: getHorizontalSize(
                        0.4,
                      ),
                    ),
                  ),
                  Padding(
                    padding: getPadding(
                      top: 5,
                    ),
                    child: Text(
                      review.comment!,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManrope12Gray900.copyWith(
                        letterSpacing: getHorizontalSize(
                          0.4,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: getPadding(
                      top: 3,
                    ),
                    child: RatingBar.builder(
                      initialRating: review.stars!,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemSize: getSize(16),
                      itemCount: 5,
                      ignoreGestures: true,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        // _rate = rating;
                        // print(rating);
                      },
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
