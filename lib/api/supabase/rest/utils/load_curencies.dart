import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> loadCurrencies() async {
  try {
    final list = await supabase
        .from("currencies")
        .select<List<Map<String, dynamic>>>("id, currency, en, fr")
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
