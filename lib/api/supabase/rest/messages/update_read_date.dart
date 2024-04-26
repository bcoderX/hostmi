import 'package:flutter/material.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<DatabaseResponse> updateReadMessage(String messageId) async {
  try {
    final list = await supabase.from("messages").update({
      "read_date": DateTime.now().toString(),
      "is_read": true,
    }).match({
      "id": messageId,
    }).select<List<Map<String, dynamic>>>();
    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    debugPrint(e.toString());
    return const DatabaseResponse();
  }
}
