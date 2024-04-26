import 'package:flutter/widgets.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<bool> updateCoords({
  required double lat,
  required double long,
  required String houseId,
}) async {
  try {
    final response = await supabase.from("houses").update(
      {
        "latitude": lat,
        "longitude": long,
        "location": "POINT($long $lat)",
      },
    ).match({"id": houseId}).select<List<Map<String, dynamic>>>();
    debugPrint("response:$response");
    return response.isNotEmpty;
  } catch (error) {
    debugPrint(error.toString());
    return false;
  }
}
