import 'package:flutter/material.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:latlong2/latlong.dart';

Future<DatabaseDynamicResponse> getNearbyHouses(
    LatLng coords, double distance, int houseTypeId) async {
  try {
    final list = await supabase
        .rpc("nearby_houses", params: {
          "lat": coords.latitude,
          "long": coords.longitude,
          "distance": distance,
          "house_type": houseTypeId,
        })
        .eq("house_type", houseTypeId)
        .is_("is_deleted", false)
        .is_("is_hidden", false)
        .is_("is_under_verification", false)
        .is_("is_accepted", true)
        .is_("is_available", true);
    debugPrint(houseTypeId.toString());
    return DatabaseDynamicResponse(isSuccess: true, list: list);
  } catch (e) {
    debugPrint(e.toString());
  }
  return const DatabaseDynamicResponse();
}

Future<DatabaseDynamicResponse> getAllNearbyHouses(
    LatLng coords, double distance) async {
  try {
    final list = await supabase
        .rpc(
          "nearby_houses",
          params: {
            "lat": coords.latitude,
            "long": coords.longitude,
            "distance": distance,
          },
        )
        .is_("is_deleted", false)
        .is_("is_hidden", false)
        .is_("is_under_verification", false)
        .is_("is_accepted", true)
        .is_("is_available", true);
    debugPrint("Hello");
    // debugPrint(list.toString());
    return DatabaseDynamicResponse(isSuccess: true, list: list);
  } catch (e) {
    debugPrint(e.toString());
  }
  return const DatabaseDynamicResponse();
}
