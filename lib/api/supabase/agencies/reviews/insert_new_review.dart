import 'package:flutter/material.dart';
import 'package:hostmi/api/models/review_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> insertNewReview(ReviewModel review) async {
  try {
    final list = await supabase.from("agency_reviews").insert(
      {
        "user_id": review.userId,
        "agency_id": review.agencyId,
        "stars": review.stars,
        "comment": review.comment,
      },
    ).select<List<Map<String, dynamic>>>();

    return list;
  } catch (e) {
    debugPrint(e.toString());
    return [];
  }
}
