import 'package:flutter/widgets.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<PostgrestResponse<dynamic>?> selectHouses(
    {required int from, required int to, required List<String> cities}) async {
  try {
    PostgrestResponse response = await supabase
        .from("houses")
        .select(
          "id, created_at, available_on, main_image_url, price, bedrooms, bathrooms, features, sector, quarter, city, full_address, longitude, latitude, description, agency_id, house_types(id, en, fr), house_categories(id, en, fr), price_types(id, en, fr), currencies(id, currency, en, fr), countries(id, alpha2, en, fr), houses_pictures(id, image_url)",
          const FetchOptions(count: CountOption.estimated),
        )
        .eq("houses_pictures.role", "1")
        .is_("is_available", true)
        .is_("is_deleted", false)
        .is_("is_hidden", false)
        .ilikeAnyOf("city", cities)
        .is_("is_under_verification", false)
        .is_("is_accepted", true)
        .order("available_on", ascending: false);
    // print(list);
    return response;
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}

Future<List<Map<String, dynamic>>> selectHousesByType(int type) async {
  try {
    final list = await supabase
        .from("houses")
        .select<List<Map<String, dynamic>>>(
          "id, created_at, available_on, main_image_url, price, bedrooms, bathrooms, features, sector, quarter, city, full_address, longitude, latitude, description, agency_id, house_types(id, en, fr), house_categories(id, en, fr), price_types(id, en, fr), currencies(id, currency, en, fr), countries(id, alpha2, en, fr), houses_pictures(id, image_url)",
        )
        .eq("houses_pictures.role", "1")
        .eq("house_type", "$type")
        .is_("is_available", true)
        .order("available_on", ascending: false);
    // print(list);
    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<DatabaseResponse> selectHouseByID(String id) async {
  try {
    final list = await supabase
        .from("houses")
        .select<List<Map<String, dynamic>>>(
          "id, agency_id, created_at, available_on, main_image_url, price, features, bedrooms, bathrooms, sector, quarter, city, full_address, longitude, latitude, description, access_conditions, agency_id, house_types(id, en, fr), house_categories(id, en, fr), price_types(id, en, fr), gender(id, en, fr), jobs(id, en, fr), marital_status(id, en, fr), currencies(id, currency, en, fr), countries(id, alpha2, en, fr), houses_pictures(id, image_url, description), agencies(id, phone_number, whatsapp, is_verified)",
        )
        .eq("id", id)
        .is_("is_available", true)
        .is_("is_deleted", false)
        .is_("is_hidden", false)
        .is_("is_under_verification", false)
        .is_("is_accepted", true);
    print(list[0]["agencies"]);
    return DatabaseResponse(isSuccess: true, list: list);
  } catch (e) {
    print(e);
    return const DatabaseResponse();
  }
}

Future<List<Map<String, dynamic>>> selectHousesByAgency(String id) async {
  try {
    final list = await supabase
        .from("houses")
        .select<List<Map<String, dynamic>>>(
          "id, agency_id, created_at, available_on, is_accepted, is_under_verification, main_image_url, price, features, bedrooms, bathrooms, sector, quarter, city, full_address, longitude, latitude, description, agency_id, is_available, is_accepted, house_types(id, en, fr), house_categories(id, en, fr), price_types(id, en, fr), currencies(id, currency, en, fr), countries(id, alpha2, en, fr), houses_pictures(id, image_url), agencies(id, phone_number)",
        )
        .eq("agency_id", id)
        .eq("houses_pictures.role", "1")
        .is_("is_deleted", false)
        .is_("is_hidden", false)
        .order(
          "available_on",
          ascending: false,
        );
    // print(list);
    return list;
  } catch (e) {
    // print(e);
    return [];
  }
}

Future<List<Map<String, dynamic>>> selectHousesByAgencyForUsers(
    String id) async {
  try {
    final list = await supabase
        .from("houses")
        .select<List<Map<String, dynamic>>>(
          "id, agency_id, created_at, available_on, main_image_url, price, features, bedrooms, bathrooms, sector, quarter, city, full_address, longitude, latitude, description, agency_id, is_available, house_types(id, en, fr), house_categories(id, en, fr), price_types(id, en, fr), currencies(id, currency, en, fr), countries(id, alpha2, en, fr), houses_pictures(id, image_url), agencies(id, phone_number)",
        )
        .eq("agency_id", id)
        .eq("houses_pictures.role", "1")
        .is_("is_available", true)
        .is_("is_hidden", false)
        .is_("is_accepted", true)
        .is_("is_deleted", false)
        .is_("is_under_verification", false)
        .order("available_on", ascending: false);
    // print(list);
    return list;
  } catch (e) {
    // print(e);
    return [];
  }
}
