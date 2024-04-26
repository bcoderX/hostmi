import 'package:flutter/widgets.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<bool> deleteHouse(String houseId) async {
  try {
    final response = await supabase.from("houses").update(
      {
        "is_deleted": true,
      },
    ).match({"id": houseId}).select<List<Map<String, dynamic>>>();
    debugPrint("response:$response");
    return response.isNotEmpty;
  } catch (error) {
    debugPrint(error.toString());
    return false;
  }
}
