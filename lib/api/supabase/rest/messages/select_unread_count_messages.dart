import 'package:flutter/material.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<DatabaseResponse> selectUnreadCountMessages(
    String chatId, String receiverId) async {
  try {
    PostgrestResponse getCount = await supabase
        .from("messages")
        .select("*", const FetchOptions(count: CountOption.exact, head: true))
        .eq("chat_id", chatId)
        .eq("is_read", false)
        .eq("receiver_id", receiverId);
    return DatabaseResponse(isSuccess: true, count: getCount.count!);
  } catch (e) {
    debugPrint(e.toString());
    return const DatabaseResponse();
  }
}
