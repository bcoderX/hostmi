// import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> createAgency(int id) async {
  final list = await supabase
      .useSchema("real_estate_developer")
      .from("agencies")
      .select<List<Map<String, dynamic>>>()
      .eq("id", id);

  return list;
}
