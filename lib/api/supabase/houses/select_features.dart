import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> loadHouseFeaturesByIds(
    List<dynamic> features) async {
  try {
    final list = await supabase
        .from("house_features")
        .select<List<Map<String, dynamic>>>("id, en, fr")
        .in_("id", features);
    print(list);
    return list;
  } catch (e) {
    print(e);
  }

  return [];
}
