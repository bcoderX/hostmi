import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> selectAgency(String userId) async {
  try {
    final list = await supabase
        .useSchema("real_estate_developer")
        .from("agency_managers")
        .select<List<Map<String, dynamic>>>(
          "user_id, agencies(*)",
        );
    print(list);
    return list;
  } catch (e) {
    print(e);
    return [];
  }
}
