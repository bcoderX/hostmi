import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> loadCountries() async {
  final list = await supabase.from("countries").select<List<Map<String, dynamic>>>("id, alpha2, en, fr");

  return list;
}