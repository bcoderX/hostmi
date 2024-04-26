import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<DatabaseResponse> updateReceiveMessage(
    String chatId, String receiverId) async {
  try {
    final list = await supabase.from("messages").update({
      "received_date": DateTime.now().toString(),
      "is_received": true,
    }).match({
      "chat_id": chatId,
      "receiver_id": receiverId,
    }).select<List<Map<String, dynamic>>>();
    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    return const DatabaseResponse();
  }
}
