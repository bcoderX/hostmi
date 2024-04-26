import 'package:flutter/material.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<DatabaseResponse> deleteMessage(String messageId) async {
  debugPrint(messageId);
  try {
    final list = await supabase.from("messages").update({
      "is_deleted": true,
    }).match({
      "id": messageId,
    }).select<List<Map<String, dynamic>>>();
    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    debugPrint(e.toString());
    return const DatabaseResponse();
  }
}
