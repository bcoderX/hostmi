import 'package:hive/hive.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/supabase/agencies/managers/select_manager_agency.dart';
import 'package:hostmi/api/supabase/load_countries.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

import '../constants/roles.dart';

var hostmiBox = Hive.box("hostmiLocalDatabase");

String keyRole = "role";
String keyCountries = "countries";
String keyDelete = "countries";
String keyAgencyDetails = "agencyDetails";

void setInt(String key, int value) => hostmiBox.put(key, value);
void setString(String key, String value) => hostmiBox.put(key, value);
void setData(String key, dynamic value) => hostmiBox.put(key, value);

int? getInt(String key) => hostmiBox.get(key);
String? getString(String key) => hostmiBox.get(key);
dynamic getData(String key) => hostmiBox.get(key);

//Setters
void setRole(Role role) => setData(keyRole, role);
void setCountries(List<Map<String, dynamic>> countries) =>
    setData(keyCountries, countries);

void setAgencyDetails(AgencyModel? agency) => setData(keyAgencyDetails, agency);

//Getters
Role getRole() => getData(keyRole) ?? Role.UNKNOWN;

Future<AgencyModel?> getAgencyDetails() async {
  AgencyModel? agencyModel = getData(keyAgencyDetails);
  if (agencyModel == null) {
    final result = await selectAgency(supabase.auth.currentUser!.id);
    if (result.isNotEmpty) {
      agencyModel = AgencyModel.fromMap(result[0]["agencies"][0]);
      print(result);
    }
    setAgencyDetails(agencyModel);
  }
  return agencyModel;
}
