import 'package:hive/hive.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/supabase/rest/agencies/managers/select_manager_agency.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/api/utils/check_internet_status.dart';

import '../constants/roles.dart';

var hostmiBox = Hive.box("hostmiLocalDatabase");

String keyRole = "role";
String keyCountries = "countries";
String keyHouseTypes = "house_types";
String keyHouseCategories = "house_categories";
String keyPriceTypes = "price_types";
String keyHouseFeatures = "house_features";
String keyGenders = "genders";
String keyCurrencies = "currencies";
String keyJobs = "jobs";
String keyMaritalStatus = "marital_status";
String keyDelete = "countries";
String keyAgencyDetails = "agencyDetails";
String keyIsProfileCompleted = "isProfileCompletted";
String keyStartupPage = "showStartupPage";
String keyCurrentDbVersion = "currentDbVersion";

void setInt(String key, int value) => hostmiBox.put(key, value);
void setString(String key, String value) => hostmiBox.put(key, value);
void setData(String key, dynamic value) => hostmiBox.put(key, value);

int? getInt(String key) => hostmiBox.get(key);
String? getString(String key) => hostmiBox.get(key);
dynamic getData(String key) => hostmiBox.get(key);

//Setters
void setRole(Role role) => setData(keyRole, role);
void setShowStartupPage(bool show) => setData(keyStartupPage, show);
void setCountries(List<Map<String, dynamic>> countries) =>
    setData(keyCountries, countries);
void setHouseTypes(List<Map<String, dynamic>> houseTypes) =>
    setData(keyHouseTypes, houseTypes);
void setHouseCategories(List<Map<String, dynamic>> houseCategories) =>
    setData(keyHouseCategories, houseCategories);
void setPriceTypes(List<Map<String, dynamic>> priceTypes) =>
    setData(keyPriceTypes, priceTypes);
void setHouseFeatures(List<Map<String, dynamic>> houseFeatures) =>
    setData(keyHouseFeatures, houseFeatures);
void setGenders(List<Map<String, dynamic>> genders) =>
    setData(keyGenders, genders);
void setJobs(List<Map<String, dynamic>> jobs) => setData(keyJobs, jobs);
void setMaritalStatus(List<Map<String, dynamic>> maritalStatus) =>
    setData(keyMaritalStatus, maritalStatus);
void setCurrencies(List<Map<String, dynamic>> currencies) =>
    setData(keyCurrencies, currencies);

void setAgencyDetails(AgencyModel agency) => setData(keyAgencyDetails, agency);
void setIsProfileCompleted(bool isCompleted) =>
    setData(keyIsProfileCompleted, isCompleted);

void setCurrentDbVersion(String version) =>
    setData(keyCurrentDbVersion, version);

//Getters
Role getRole() => getData(keyRole) ?? Role.UNKNOWN;
bool getIsProfileCompleted() => getData(keyIsProfileCompleted) ?? false;
bool getShowStartupPage() => getData(keyStartupPage) ?? true;
String getCurrentDbVersion() => getData(keyCurrentDbVersion) ?? "1.0.0+1";

Future<List<AgencyModel?>> getAgencyDetails() async {
  bool isOnline = await checkInternetStatus();
  AgencyModel? agencyModel = isOnline ? null : getData(keyAgencyDetails);
  if (agencyModel == null && isOnline && supabase.auth.currentUser != null) {
    final result = await selectAgency(supabase.auth.currentUser!.id);
    if (result.isNotEmpty) {
      agencyModel = AgencyModel.fromMap(result[0]["agencies"]);
      setAgencyDetails(agencyModel);
      //print(result);
    } else {
      return [];
    }
  }
  return [agencyModel];
}
