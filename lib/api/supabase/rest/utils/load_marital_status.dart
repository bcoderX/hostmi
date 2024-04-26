import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> loadMaritalStatus() async {
  try {
    final list = await supabase
        .from("marital_status")
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
