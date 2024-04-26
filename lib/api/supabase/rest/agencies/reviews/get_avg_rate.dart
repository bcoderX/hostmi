import 'package:flutter/material.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<dynamic>> getAgencyAvgRate(String agencyId) async {
  try {
    final list = await supabase
        .rpc("get_agency_avg_rate", params: {"agency_id": agencyId});
    debugPrint(list.toString());
    return list;
  } catch (e) {
    debugPrint(e.toString());
  }
  return [];
}
