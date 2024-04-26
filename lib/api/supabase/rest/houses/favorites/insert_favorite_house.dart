import 'package:flutter/material.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<bool> insertFavoriteHouse(
    {required String userId, required String houseId}) async {
  try {
    final list = await supabase.from("favorite_houses").insert(
      {
        "user_id": userId,
        "house_id": houseId,
      },
    ).select<List<Map<String, dynamic>>>();
    return list.isNotEmpty;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

Future<bool> updateFavoriteHouse(
    {required String userId,
    required String houseId,
    required bool isFav}) async {
  try {
    final list = await supabase.from("favorite_houses").update(
      {
        "is_favorite": isFav,
      },
    ).match({
      "user_id": userId,
      "house_id": houseId,
    }).select<List<Map<String, dynamic>>>();
    return list.isNotEmpty;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}

Future<List<Map<String, dynamic>>> selectFromFavorites(
    {required String userId, required String houseId}) async {
  try {
    final list = await supabase
        .from("favorite_houses")
        .select<List<Map<String, dynamic>>>("*")
        .eq("house_id", houseId)
        .eq("user_id", userId);
    return list;
  } catch (e) {
    debugPrint(e.toString());
    return [];
  }
}

Future<bool> isFavorite(
    {required String userId, required String houseId}) async {
  try {
    final result = await supabase.rpc("is_favorite_house",
        params: {"house_id": houseId, "user_id": userId});

    return result ?? false;
  } catch (e) {
    debugPrint(e.toString());
    return false;
  }
}
