import 'package:flutter/material.dart';
import 'package:hostmi/api/models/review_model.dart';
import 'package:hostmi/api/supabase/agencies/reviews/select_reviews_by_agency.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/ui/screens/ball_loading_page.dart';
import 'package:hostmi/ui/screens/product_details_screen/widgets/listrectangle4224_item_widget.dart';
import 'package:hostmi/utils/app_color.dart';

class ReviewList extends StatefulWidget {
  const ReviewList({super.key, required this.agencyId});
  final String agencyId;

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  final int _selectedIndex = 0;
  int page = 1;
  late Future<List<ReviewModel>> _future;

  @override
  void initState() {
    _future = selectReviews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: getPadding(
        top: 21,
      ),
      child: FutureBuilder<List<ReviewModel>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(height: 100, child: BallLoadingPage());
            }

            if (snapshot.hasError) {
              return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Error: ${snapshot.error}"),
                  IconButton(
                      onPressed: () {
                        _future = selectReviews();
                      },
                      icon: const Icon(
                        Icons.replay_circle_filled_rounded,
                        size: 40,
                        color: AppColor.primary,
                      ))
                ],
              ));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text("Error"));
            }
            var data = snapshot.data;
            if (data!.isEmpty) {
              return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        _future = selectReviews();
                      },
                      icon: const Icon(
                        Icons.hide_image,
                        size: 40,
                        color: AppColor.primary,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Aucun résultat.")
                ],
              ));
            }
            return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: getVerticalSize(12));
                },
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Listrectangle4224ItemWidget(review: data[index]);
                });
          }),
    );
  }

  Future<List<ReviewModel>> selectReviews() async {
    final List<Map<String, dynamic>> reviewsList =
        await selectReviewsByAgency(widget.agencyId);
    return reviewsList.map((e) => ReviewModel.fromMap(data: e)).toList();
    // setState(() {});
  }
}
