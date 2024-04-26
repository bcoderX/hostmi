import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<DatabaseResponse> selectAgencyChats(String agencyId) async {
  try {
    final list = await supabase
        .from("chats")
        .select<List<Map<String, dynamic>>>(
            "*, messages(*), profiles(avatar_url, firstname, lastname)")
        .eq("agency_id", agencyId)
        .order("created_at", foreignTable: "messages")
        .limit(1, foreignTable: "messages");
    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    return const DatabaseResponse();
  }
}

Future<DatabaseResponse> selectAgencyChatId(String chatId) async {
  try {
    final list = await supabase
        .from("chats")
        .select<List<Map<String, dynamic>>>(
            "*, messages(*), profiles(avatar_url, firstname, lastname)")
        .eq("id", chatId)
        .order("created_at", foreignTable: "messages")
        .limit(1, foreignTable: "messages");
    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    return const DatabaseResponse();
  }
}
