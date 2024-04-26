import 'package:flutter/widgets.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<PostgrestResponse?> selectAllFromFavorites(
    {required int from, required int to}) async {
  try {
    PostgrestResponse response = await supabase
        .from("favorite_houses")
        .select(
            "houses(id, created_at, available_on, main_image_url, price, bedrooms, bathrooms, features, sector, quarter, city, full_address, longitude, latitude, description, agency_id, house_types(id, en, fr), house_categories(id, en, fr), price_types(id, en, fr), currencies(id, currency, en, fr), countries(id, alpha2, en, fr), houses_pictures(id, image_url))",
            const FetchOptions(count: CountOption.estimated))
        .eq("houses.houses_pictures.role", "1")
        .is_("houses.is_available", true)
        .is_("houses.is_hidden", false)
        .is_("houses.is_accepted", true)
        .is_("is_favorite", true)
        .order("created_at", ascending: false)
        .range(from, to);
    debugPrint(response.data.toString());
    return response;
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}
