import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

Future<List<Map<String, dynamic>>> createAgency(HouseModel house) async {
  AgencyModel? agencyModel = getData(keyAgencyDetails);
  if (agencyModel != null) {
    try {
      final list = await supabase
          .useSchema("real_estate_developer")
          .from("houses")
          .insert({
        "created_by": supabase.auth.currentUser!.id,
        "agency_id": agencyModel.id,
        "house_type": house.houseType,
        "full_address": house.fullAddress,
        "price": house.price,
        "country": house.country,
        "city": house.city,
        "quarter": house.quarter,
        "sector": house.sector,
        "target_job": house.occupation,
        "target_gender": house.gender,
        "target_marital_status": house.maritalStatus,
        "description": house.description,
        "longitude": house.longitude,
        "latitude": house.latitude,
        "features": house.features,
        "price_type": house.priceType,
        "bedrooms": house.beds,
        "bathrooms": house.bathrooms,
      }).select<List<Map<String, dynamic>>>();

      return list;
    } catch (e) {
      print(e);
    }
  }
  return [];
}
