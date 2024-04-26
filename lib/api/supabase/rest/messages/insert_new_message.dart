import 'package:flutter/material.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/models/message_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<DatabaseResponse> insertNewMessage(MessageModel mess) async {
  try {
    final list = await supabase.from("messages").insert({
      "created_by": supabase.auth.currentUser!.id,
      "chat_id": mess.chatId,
      "sender_id": mess.senderId,
      "receiver_id": mess.receiverId,
      "content": mess.content,
      "is_file": mess.isFile,
      "file_type": mess.fileType,
    }).select<List<Map<String, dynamic>>>();
    debugPrint(mess.userId);
    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    debugPrint(e.toString());
    return const DatabaseResponse();
  }
}
