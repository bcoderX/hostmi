import 'package:flutter/material.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<DatabaseResponse> insertNewHostmiReview(
    Map<String, dynamic> review) async {
  try {
    final list = await supabase.from("hostmi_reviews").insert(
      {
        "user_id": review["user_id"],
        "full_name": review["full_name"],
        "stars": review["stars"],
        "comment": review["comment"],
        "contact": review["contact"],
      },
    ).select<List<Map<String, dynamic>>>();

    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    debugPrint(e.toString());
    return const DatabaseResponse();
  }
}
