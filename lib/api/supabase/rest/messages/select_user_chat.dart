import 'package:flutter/material.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<DatabaseResponse> selectUserChat(String userId, agencyId) async {
  try {
    final list = await supabase
        .from("chats")
        .select<List<Map<String, dynamic>>>(
            "*, agencies(name, profile_image_url)")
        .eq("user_id", userId)
        .eq("agency_id", agencyId);
    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    debugPrint(e.toString());
    return const DatabaseResponse();
  }
}
