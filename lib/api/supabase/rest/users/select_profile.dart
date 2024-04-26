import 'package:flutter/material.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<DatabaseResponse> getProfile(String userId) async {
  try {
    final list = await supabase
        .from("profiles")
        .select<List<Map<String, dynamic>>>("*")
        .eq("id", userId);
    debugPrint(list.toString());
    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    debugPrint(e.toString());
    return const DatabaseResponse();
  }
}
