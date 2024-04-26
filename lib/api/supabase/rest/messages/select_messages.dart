import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<DatabaseResponse> selectMessages(String chatId) async {
  try {
    final list = await supabase
        .from("messages")
        .select<List<Map<String, dynamic>>>("*")
        .eq("chat_id", chatId);
    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    return const DatabaseResponse();
  }
}
