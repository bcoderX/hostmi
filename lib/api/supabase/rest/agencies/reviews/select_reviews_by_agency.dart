import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> selectReviewsByAgency(String id) async {
  try {
    final list = await supabase
        .from("agency_reviews")
        .select<List<Map<String, dynamic>>>(
          "*, profiles(firstname, lastname, avatar_url)",
        )
        .match({"agency_id": id}).is_("is_blocked", false);
    print(list);
    return list;
  } catch (e) {
    // print(e);
    return [];
  }
}
