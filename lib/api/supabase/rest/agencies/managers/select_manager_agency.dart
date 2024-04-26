import 'package:flutter/material.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> selectAgency(String userId) async {
  try {
    final list = await supabase
        .from("agency_managers")
        .select<List<Map<String, dynamic>>>(
          "user_id, agencies(*)",
        )
        .is_("agencies.is_blocked", false)
        .is_("agencies.is_deleted", false);
    debugPrint(list.toString());
    return list;
  } catch (e) {
    debugPrint(e.toString());
    return [];
  }
}
