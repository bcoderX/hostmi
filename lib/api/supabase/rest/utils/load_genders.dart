import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> loadGenders() async {
  try {
    final list = await supabase
        .from("gender")
        .select<List<Map<String, dynamic>>>("id, en, fr");
    // print(list);
    return list;
  } catch (e) {
    print(e);
  }

  return [];
}
