import 'package:flutter/material.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<bool> addHousePicture(
    {required String houseId,
    required String imageUrl,
    required int role,
    required String description}) async {
  try {
    final response = await supabase
        .from("houses_pictures")
        .insert(
      {
        'image_url': imageUrl,
        'description': description,
        'house_id': houseId,
        'role': role,
        'user_id': supabase.auth.currentUser!.id,
      },
    ).select<List<Map<String, dynamic>>>();
    return response.isNotEmpty;
  } catch (error) {
    debugPrint(error.toString());
    return false;
  }
}
