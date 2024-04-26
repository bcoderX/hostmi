import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> loadPriceTypes() async {
  try {
    final list = await supabase
        .from("price_types")
        .select<List<Map<String, dynamic>>>("id, en, fr")
        .order(
          "id",
          ascending: true,
        );
    //print(list);
    return list;
  } catch (e) {
    print(e);
  }

  return [];
}
