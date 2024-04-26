import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> loadHouseCategories() async {
  try {
    final list = await supabase
        .from("house_categories")
        .select<List<Map<String, dynamic>>>("id, en, fr");
    // print(list);
    return list;
  } catch (e) {
    print(e);
  }

  return [];
}
