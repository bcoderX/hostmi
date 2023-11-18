import 'package:flutter/material.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<bool> addAgencyPicture({
  required String agencyId,
  required String imageUrl,
  bool isProfileImage = true,
}) async {
  Map<String, dynamic> data = isProfileImage
      ? {
          'profile_image_url': imageUrl,
          'updated_by': supabase.auth.currentUser!.id,
        }
      : {
          'cover_image_url': imageUrl,
          'updated_by': supabase.auth.currentUser!.id,
        };
  try {
    final response = await supabase
        .from("agencies")
        .update(
          data,
        )
        .match({"id": agencyId}).select();
    print("response:$response");
    return response.isNotEmpty;
  } catch (error) {
    debugPrint(error.toString());
    return false;
  }
}
