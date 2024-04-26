import 'package:flutter/material.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<DatabaseResponse> getProfileStatus(String userId) async {
  try {
    final bool isCompleted =
        await supabase.rpc("is_profile_completed", params: {"user_id": userId});

    return DatabaseResponse(isSuccess: true, isTrue: isCompleted);
  } catch (e) {
    debugPrint(e.toString());
    return const DatabaseResponse();
  }
}
