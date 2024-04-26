import 'package:flutter/material.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/models/review_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> insertNewAgencyReview(
    ReviewModel review) async {
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

Future<List<Map<String, dynamic>>> updateAgencyReview(
    ReviewModel review) async {
  try {
    final list = await supabase.from("agency_reviews").update(
      {
        "stars": review.stars,
        "comment": review.comment,
      },
    ).match({
      "user_id": review.userId,
      "agency_id": review.agencyId,
    }).select<List<Map<String, dynamic>>>();

    return list;
  } catch (e) {
    debugPrint(e.toString());
    return [];
  }
}

Future<DatabaseResponse> selectUserAgencyReview(ReviewModel review) async {
  try {
    final list = await supabase
        .from("agency_reviews")
        .select("*")
        .eq("user_id", review.userId)
        .eq("agency_id", review.agencyId)
        .select<List<Map<String, dynamic>>>();

    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    debugPrint(e.toString());
    return const DatabaseResponse();
  }
}
