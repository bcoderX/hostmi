import 'package:flutter/material.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<bool> insertNewView(
    {required String userId, required String houseId}) async {
  try {
    final list = await supabase.from("houses_views").insert(
      {
        "user_id": userId.isEmpty ? null : userId,
        "house_id": houseId,
      },
    ).select<List<Map<String, dynamic>>>();

    return list.isNotEmpty;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

Future<bool> selectViewsWithNullUser({required String houseId}) async {
  try {
    final list = await supabase
        .from("houses_views")
        .select<List<Map<String, dynamic>>>("*")
        .eq("house_id", houseId)
        .is_("user_id", null);

    return list.isNotEmpty;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

Future<bool> selectViewsWithUser(
    {required String userId, required String houseId}) async {
  try {
    final list = await supabase
        .from("houses_views")
        .select<List<Map<String, dynamic>>>("*")
        .eq("house_id", houseId)
        .eq("user_id", userId);

    return list.isNotEmpty;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}
