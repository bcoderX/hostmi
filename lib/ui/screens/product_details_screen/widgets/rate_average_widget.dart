import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hostmi/api/supabase/rest/agencies/reviews/get_avg_rate.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/theme/app_style.dart';

class RateAverageWidget extends StatefulWidget {
  const RateAverageWidget({super.key, required this.agencyId});
  final String agencyId;

  @override
  State<RateAverageWidget> createState() => _RateAverageWidgetState();
}

class _RateAverageWidgetState extends State<RateAverageWidget> {
  late Future<List<dynamic>> _agencyFuture;
  @override
  void initState() {
    _agencyFuture = getAgencyAvgRate(widget.agencyId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getPadding(left: 8, top: 14),
      child: FutureBuilder<List<dynamic>>(
        future: _agencyFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: getPadding(
                      top: 23,
                    ),
                    child: Text(
                        "Avis sur l'${snapshot.data!.first['is_agency'] ? 'agence' : 'annonceur'}",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeBold18
                            .copyWith(letterSpacing: getHorizontalSize(0.2)))),
                Row(children: [
                  Text(
                      "${double.tryParse(snapshot.data!.first['stars'].toString())}",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtManropeBold32
                          .copyWith(letterSpacing: getHorizontalSize(0.2))),
                  RatingBar.builder(
                    initialRating: double.tryParse(
                            snapshot.data!.first['stars'].toString()) ??
                        0.0,
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
                  Padding(
                      padding: getPadding(left: 14, top: 15, bottom: 11),
                      child: Text(
                          "${snapshot.data!.first['reviews_count']} avis",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtManropeMedium12Gray900
                              .copyWith(letterSpacing: getHorizontalSize(0.4))))
                ]),
              ],
            );
          }
          return Row(children: [
            Text("--",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: AppStyle.txtManropeBold32
                    .copyWith(letterSpacing: getHorizontalSize(0.2))),
            RatingBar.builder(
              initialRating: 0,
              minRating: 0,
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
            Padding(
                padding: getPadding(left: 14, top: 15, bottom: 11),
                child: Text("-- avis",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtManropeMedium12Gray900
                        .copyWith(letterSpacing: getHorizontalSize(0.4))))
          ]);
        },
      ),
    );
  }
}
