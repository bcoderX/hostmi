import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> selectAgencyByID(String id) async {
  try {
    final list = await supabase
        .from("agencies")
        .select<List<Map<String, dynamic>>>(
          "*",
        )
        .eq("id", id);
    // print(list);
    return list;
  } catch (e) {
    // print(e);
    return [];
  }
}
