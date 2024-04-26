import 'package:flutter/material.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<bool> addProfilePicture({
  required String userId,
  required String imageUrl,
}) async {
  debugPrint(DateTime.now().toString());
  Map<String, dynamic> data = {
    'updated_at': DateTime.now().toString(),
    'avatar_url': imageUrl,
  };
  try {
    final response = await supabase
        .from("profiles")
        .update(data)
        .match({"id": userId}).select<List<Map<String, dynamic>>>();
    return response.isNotEmpty;
  } catch (error) {
    debugPrint(error.toString());
    return false;
  }
}
