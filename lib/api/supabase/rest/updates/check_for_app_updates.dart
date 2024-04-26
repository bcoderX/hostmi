import 'package:flutter/material.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<DatabaseResponse> checkForUpdates() async {
  try {
    final list = await supabase
        .from("updates")
        .select<List<Map<String, dynamic>>>(
            "id, created_at, version, is_required, expiration_date")
        .order("created_at")
        .limit(1);
    print(list);
    return DatabaseResponse(list: list, isSuccess: true);
  } catch (e) {
    debugPrint(e.toString());
  }

  return const DatabaseResponse();
}
