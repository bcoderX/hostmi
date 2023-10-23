import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> loadHouseTypes() async {
  try {
    final list = await supabase
        .useSchema("real_estate_developer")
        .from("house_types")
        .select<List<Map<String, dynamic>>>("id, en, fr");
    //print(list);
    return list;
  } catch (e) {
    print(e);
  }

  return [];
}
