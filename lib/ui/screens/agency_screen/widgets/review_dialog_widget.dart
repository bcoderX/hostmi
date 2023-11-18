import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hostmi/api/models/review_model.dart';
import 'package:hostmi/api/supabase/agencies/reviews/insert_new_review.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ReviewDialogWidget extends StatefulWidget {
  const ReviewDialogWidget({super.key, required this.agencyId});
  final String agencyId;

  @override
  State<ReviewDialogWidget> createState() => _ReviewDialogWidgetState();
}

class _ReviewDialogWidgetState extends State<ReviewDialogWidget> {
  final TextEditingController _commentController = TextEditingController();
  double _rate = 0;
  bool _isSaving = false;
  bool _isSaved = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _isSaved
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                    size: getSize(130),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Merci pour votre avis !"),
                  )
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemSize: 30,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _rate = rating;
                      // print(rating);
                    },
                  ),
                  CustomTextFormField(
                    controller: _commentController,
                    hintText: "Laisser un commentaire",
                    margin: getMargin(top: 13),
                    maxLines: 4,
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving
                          ? () {}
                          : () async {
                              // Navigator.of(context).pop();
                              setState(() {
                                _isSaving = true;
                              });

                              final list = await insertNewReview(ReviewModel(
                                agencyId: widget.agencyId,
                                userId: supabase.auth.currentUser!.id,
                                stars: _rate,
                                comment: _commentController.text.trim(),
                              ));
                              if (list.isNotEmpty) {
                                setState(() {
                                  _isSaved = true;
                                });
                              }
                            },
                      child: _isSaving
                          ? LoadingAnimationWidget.threeArchedCircle(
                              color: AppColor.white,
                              size: getSize(25),
                            )
                          : const Text("Valider"),
                    ),
                  ),
                ],
              ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Fermer")),
        )
      ],
    );
  }
}
