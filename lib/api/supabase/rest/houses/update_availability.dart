import 'package:flutter/widgets.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<bool> toggleHouseAvailability(String houseId, bool isAvailable) async {
  try {
    final response = await supabase.from("houses").update(
      {"is_available": isAvailable, "available_on": DateTime.now().toString()},
    ).match({"id": houseId}).select<List<Map<String, dynamic>>>();
    debugPrint("response:$response");
    return response.isNotEmpty;
  } catch (error) {
    debugPrint(error.toString());
    return false;
  }
}
