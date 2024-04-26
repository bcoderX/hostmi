import 'package:flutter/material.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<DatabaseResponse> selectUserChats(String userId) async {
  try {
    final list = await supabase
        .from("chats")
        .select<List<Map<String, dynamic>>>(
          "*, messages(*), agencies(name, profile_image_url)",
        )
        .eq("user_id", userId)
        .order("created_at", ascending: false, foreignTable: "messages")
        .limit(1, foreignTable: "messages");
    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    debugPrint(e.toString());
    return const DatabaseResponse();
  }
}

Future<DatabaseResponse> selectUserChatId(String chatId) async {
  try {
    final list = await supabase
        .from("chats")
        .select<List<Map<String, dynamic>>>(
          "*, messages(*), agencies(name, profile_image_url)",
        )
        .eq("id", chatId)
        .order("created_at", ascending: false, foreignTable: "messages")
        .limit(1, foreignTable: "messages");
    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    debugPrint(e.toString());
    return const DatabaseResponse();
  }
}
