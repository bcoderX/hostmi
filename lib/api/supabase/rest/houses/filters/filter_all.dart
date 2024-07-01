import 'package:flutter/material.dart';
import 'package:hostmi/api/models/filter_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<PostgrestResponse?> filterAllHousesAttributes(
    {required FilterModel filters, required int from, required int to}) async {
  // debugPrint("entered: ${filters.types}");
  PostgrestResponse response;
  try {
    if (filters.features.isEmpty) {
      response = await supabase
          .from("houses")
          .select(
              "id, created_at, available_on, main_image_url, price, bedrooms, bathrooms, features, sector, quarter, city, full_address, longitude, latitude, description, agency_id, house_types(id, en, fr), house_categories(id, en, fr), price_types(id, en, fr), currencies(id, currency, en, fr), countries(id, alpha2, en, fr), houses_pictures(id, image_url)",
              const FetchOptions(count: CountOption.estimated))
          .gte("price", filters.minPrice)
          .lte("price", filters.maxPrice)
          .eq("price_type", filters.priceType.id)
          .eq("currency", filters.currency.id)
          .in_("house_type", filters.typesIds)
          .in_("house_category", filters.categoriesIds)
          .in_("target_gender", filters.gendersIds)
          .in_("target_job", filters.occupationsIds)
          .in_("target_marital_status", filters.maritalStatusIds)
          .filter(
            "sector",
            filters.sectors.isEmpty ? 'neq' : "in",
            filters.sectors.isEmpty ? -1 : filters.sectors,
          )
          .ilikeAnyOf("quarter", filters.quarters)
          .eq("country", filters.country.id)
          .filter("bedrooms", filters.beds < 0 ? 'neq' : 'eq', filters.beds)
          .filter("bedrooms", filters.bathrooms < 0 ? 'neq' : 'eq',
              filters.bathrooms)
          .eq("houses_pictures.role", "1")
          .is_("is_deleted", false)
          .is_("is_hidden", false)
          .is_("is_accepted", true)
          .is_("is_under_verification", false)
          .is_("is_accepted", true)
          .is_("is_available", true)
          .textSearch(
            "search_terms",
            filters.cities,
            config: 'english',
            type: TextSearchType.websearch,
          )
          .order(
            "available_on",
            ascending: false,
          )
          .range(from, to);
    } else {
      response = await supabase
          .from("houses")
          .select(
            "id, created_at, available_on, main_image_url, price, bedrooms, bathrooms, features, sector, quarter, city, full_address, longitude, latitude, description, agency_id, house_types(id, en, fr), house_categories(id, en, fr), price_types(id, en, fr), currencies(id, currency, en, fr), countries(id, alpha2, en, fr), houses_pictures(id, image_url)",
            const FetchOptions(count: CountOption.estimated),
          )
          .overlaps("features", filters.featuresIds)
          .gte("price", filters.minPrice)
          .eq("price_type", filters.priceType.id)
          .eq("currency", filters.currency.id)
          .lte("price", filters.maxPrice)
          .in_("house_type", filters.typesIds)
          .in_("house_category", filters.categoriesIds)
          .in_("target_gender", filters.gendersIds)
          .in_("target_job", filters.occupationsIds)
          .in_("target_marital_status", filters.maritalStatusIds)
          .filter("sector", filters.sectors.isEmpty ? 'neq' : "in",
              filters.sectors.isEmpty ? -1 : filters.sectors)
          .ilikeAnyOf("quarter", filters.quarters)
          .textSearch(
            "search_terms",
            filters.cities,
            config: 'english',
            type: TextSearchType.websearch,
          )
          .eq("country", filters.country.id)
          .filter("bedrooms", filters.beds < 0 ? 'neq' : 'eq', filters.beds)
          .filter("bedrooms", filters.bathrooms < 0 ? 'neq' : 'eq',
              filters.bathrooms)
          .eq("houses_pictures.role", "1")
          .is_("is_deleted", false)
          .is_("is_hidden", false)
          .is_("is_under_verification", false)
          .is_("is_accepted", true)
          .is_("is_available", true)
          .order(
            "available_on",
            ascending: false,
          )
          .range(from, to);
    }
    // print(filters.sectors);
    return response;
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}
