import 'package:flutter/material.dart';
import 'package:hostmi/api/models/chat_model.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<DatabaseResponse> createNewChat(ChatModel chat) async {
  try {
    final list = await supabase.from("chats").insert({
      "user_id": chat.userId,
      "agency_id": chat.agencyId,
    }).select<List<Map<String, dynamic>>>(
        "*, agencies(name, profile_image_url)");
    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    debugPrint(e.toString());
    return const DatabaseResponse();
  }
}
