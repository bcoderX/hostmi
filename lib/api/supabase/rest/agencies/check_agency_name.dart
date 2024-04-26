import 'package:hostmi/api/supabase/supabase_client.dart';

Future<bool> checkAgencyName(String name) async {
  try {
    final list = await supabase
        .from("agencies")
        .select<List<Map<String, dynamic>>>("*")
        .ilike("name", name);
    return list.isNotEmpty;
  } catch (e) {
    print(e);
    return false;
  }
}
