import 'package:flutter/widgets.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> selectHouses() async {
  try {
    final list = await supabase
        .from("houses")
        .select<List<Map<String, dynamic>>>(
          "id, created_at, main_image_url, price, bedrooms, bathrooms, features, sector, quarter, city, full_address, longitude, latitude, description, house_types(id, en, fr), house_categories(id, en, fr), price_types(id, en, fr), currencies(id, currency, en, fr), countries(id, alpha2, en, fr), houses_pictures(id, image_url)",
        )
        .eq("houses_pictures.role", "1")
        .order("created_at", ascending: false);
    // print(list);
    return list;
  } catch (e) {
    debugPrint(e.toString());
    return [];
  }
}

Future<List<Map<String, dynamic>>> selectHousesByType(int type) async {
  try {
    final list = await supabase
        .from("houses")
        .select<List<Map<String, dynamic>>>(
          "id, created_at, main_image_url, price, bedrooms, bathrooms, features, sector, quarter, city, full_address, longitude, latitude, description, house_types(id, en, fr), house_categories(id, en, fr), price_types(id, en, fr), currencies(id, currency, en, fr), countries(id, alpha2, en, fr), houses_pictures(id, image_url)",
        )
        .eq("houses_pictures.role", "1")
        .eq("house_type", "$type")
        .order("created_at", ascending: false);
    // print(list);
    return list;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List<Map<String, dynamic>>> selectHouseByID(String id) async {
  try {
    final list = await supabase
        .from("houses")
        .select<List<Map<String, dynamic>>>(
          "id, agency_id, created_at, main_image_url, price, features, bedrooms, bathrooms, sector, quarter, city, full_address, longitude, latitude, description, house_types(id, en, fr), house_categories(id, en, fr), price_types(id, en, fr), currencies(id, currency, en, fr), countries(id, alpha2, en, fr), houses_pictures(id, image_url), agencies(id, phone_number)",
        )
        .eq("id", id);
    // print(list);
    return list;
  } catch (e) {
    // print(e);
    return [];
  }
}

Future<List<Map<String, dynamic>>> selectHousesByAgency(String id) async {
  try {
    final list = await supabase
        .from("houses")
        .select<List<Map<String, dynamic>>>(
          "id, agency_id, created_at, main_image_url, price, features, bedrooms, bathrooms, sector, quarter, city, full_address, longitude, latitude, description, house_types(id, en, fr), house_categories(id, en, fr), price_types(id, en, fr), currencies(id, currency, en, fr), countries(id, alpha2, en, fr), houses_pictures(id, image_url), agencies(id, phone_number)",
        )
        .eq("agency_id", id);
    // print(list);
    return list;
  } catch (e) {
    // print(e);
    return [];
  }
}
