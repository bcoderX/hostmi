import 'package:flutter/material.dart';
import 'package:hostmi/api/models/user_profile_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:intl/intl.dart';

Future<bool> updateProfile({required UserProfileModel profile}) async {
  Map<String, dynamic> data = {
    "gender": profile.gender,
    "job_title": profile.jobTitle,
    "birthday": DateFormat("yyyy-MM-dd").format(profile.birthday!),
    "country": profile.country,
    "lastname": profile.lastname,
    "firstname": profile.firstname,
  };
  try {
    final response = await supabase
        .from("profiles")
        .update(data)
        .match({"id": profile.id}).select();
    return response.isNotEmpty;
  } catch (error) {
    debugPrint(error.toString());
    return false;
  }
}
