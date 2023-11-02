import 'package:flutter/material.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> createAgency(AgencyModel agency) async {
  try {
    final list = await supabase
        .from("agencies")
        .insert(
      {
        "country_id": agency.countryId,
        "name": agency.name,
        "phone_number": agency.phoneNumber,
        "email": agency.email,
        "cities": agency.cities,
        "description": agency.description,
        "address": agency.address,
        "created_by": supabase.auth.currentUser!.id,
      },
    ).select<List<Map<String, dynamic>>>();

    return list;
  } catch (e) {
    debugPrint(e.toString());
    return [];
  }
}
