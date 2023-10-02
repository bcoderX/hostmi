import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/schemas/authentication_schema.dart';
import 'package:hostmi/api/schemas/page_schema.dart';
import 'package:hostmi/api/utils/end_point.dart';

import '../supabase/load_countries.dart';

class HostmiProvider with ChangeNotifier {
  //Create agency data
  String _agencyName = "";
  String _agencyCountryId = "854";
  String _agencyCountryName = "Burkina Faso";
  String _agencyDescription = "";
  String _agencyPhone = "";
  String _agencyEmail = "";
  String _agencyAdress = "";
  String _agencyTowns = "";
  List<dynamic> _countriesList = [];

  String get agencyName => _agencyName;
  String get agencyCountryId => _agencyCountryId;
  String get agencyCountryName => _agencyCountryName;
  String get agencyDescription => _agencyDescription;
  String get agencyPhone => _agencyPhone;
  String get agencyEmail => _agencyEmail;
  String get agencyAdress => _agencyAdress;
  String get agencyTowns => _agencyTowns;
  List<dynamic> get countriesList {
    if (_countriesList.isEmpty) {
      getCountries();
    }
    return _countriesList;
  }

  void setAgencyName(String name) {
    _agencyName = name;
    notifyListeners();
  }

  void setAgencyCountry(String id, String name) {
    _agencyCountryId = id;
    _agencyCountryName = name;
    notifyListeners();
  }

  void setAgencyDescription(String description) {
    _agencyDescription = description;
    notifyListeners();
  }

  void setAgencyPhone(String phone) {
    _agencyPhone = phone;
    notifyListeners();
  }

  void setAgencyEmail(String email) {
    _agencyEmail = email;
    notifyListeners();
  }

  void setAgencyAddress(String address) {
    _agencyAdress = address;
    notifyListeners();
  }

  void setAgencyPlace(String cities) {
    _agencyTowns = cities;
    notifyListeners();
  }

  //End Create agency data

  //Countries List
  void setCountriesList(List<dynamic> coutries) {
    _countriesList = coutries;
    notifyListeners();
  }

  void getCountries() {
    List<dynamic> list = getData(keyCountries) ?? [];
    if (list.isEmpty) {
      loadCountries().then((results) {
        setCountriesList(results);
        setCountries(results);
      }, onError: (result) {
        getCountries();
      });
    } else {
      setCountriesList(list);
    }
  }
}
