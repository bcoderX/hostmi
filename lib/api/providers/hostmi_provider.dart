import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hostmi/api/models/country_model.dart';
import 'package:hostmi/api/models/currency.dart';
import 'package:hostmi/api/models/filter_model.dart';
import 'package:hostmi/api/models/gender.dart';
import 'package:hostmi/api/models/house_category.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/models/house_type.dart';
import 'package:hostmi/api/models/job.dart';
import 'package:hostmi/api/models/marital_status.dart';
import 'package:hostmi/api/models/price_type.dart';
import 'package:hostmi/api/supabase/utils/load_curencies.dart';
import 'package:hostmi/api/supabase/utils/load_genders.dart';
import 'package:hostmi/api/supabase/utils/load_house_categories.dart';
import 'package:hostmi/api/supabase/utils/load_house_features.dart';
import 'package:hostmi/api/supabase/utils/load_house_types.dart';
import 'package:hostmi/api/supabase/utils/load_jobs.dart';
import 'package:hostmi/api/supabase/utils/load_marital_status.dart';
import 'package:hostmi/api/supabase/utils/load_price_types.dart';
import '../hostmi_local_database/hostmi_local_database.dart';
import '../supabase/utils/load_countries.dart';

class HostmiProvider with ChangeNotifier {
  //Create agency variables
  String _agencyName = "";
  String _agencyCountryId = "854";
  String _agencyCountryName = "Burkina Faso";
  String _agencyDescription = "";
  String _agencyPhone = "";
  String _agencyEmail = "";
  String _agencyAdress = "";
  String _agencyTowns = "";
  List<dynamic> _countriesList = [
    {
      "id": "854",
      "en": "Burkina Faso",
      "fr": "Burkina Faso",
    }
  ];

  List<dynamic> _houseTypesList = [
    {
      "id": "1",
      "en": "Simple house",
      "fr": "Maison simple",
    }
  ];
  List<dynamic> _houseCategoriesList = [
    {
      "id": "1",
      "en": "Unique house",
      "fr": "Cours unique",
    }
  ];
  List<dynamic> _priceTypesList = [
    {
      "id": "1",
      "en": "monthly",
      "fr": "par mois",
    }
  ];

  List<dynamic> _gendersList = [
    {
      "id": "3",
      "en": "Any",
      "fr": "N'importe lequel",
    }
  ];
  List<dynamic> _jobsList = [
    {
      "id": "4",
      "en": "Any",
      "fr": "N'importe lequel",
    }
  ];
  List<dynamic> _maritalStatusList = [
    {
      "id": "3",
      "en": "Any",
      "fr": "N'importe lequel",
    }
  ];

  List<dynamic> _currenciesList = [
    {
      "id": "159",
      "currency": "XOF",
      "en": "CFA Franc BCEAO",
      "fr": "",
    }
  ];

  List<dynamic> _houseFeaturesList = [];
  bool _isOnline = true;

  // add house variables'
  final File? _mainImage = null;
  final String _houseType = "";
  final int _numberOfBeds = 0;
  final int _numberOfBaths = 0;
  final String _priceType = "";
  final int _price = 0;
  HouseModel _houseForm = HouseModel(
    beds: 0,
    bathrooms: 0,
    country: Country(id: 854),
    priceType: const PriceType(
      id: 1,
      en: "/month",
      fr: "/mois",
    ),
    houseType: const HouseType(id: 1, en: "Simple house", fr: "Maison simple"),
    houseCategory:
        const HouseCategory(id: 1, en: "Unique house", fr: "Cours unique"),
    price: 0,
    currency:
        const Currency(id: 159, currency: "XOF", en: "CFA Franc BCEAO", fr: ""),
    gender: const Gender(id: 3),
    occupation: const Job(id: 4),
    maritalStatus: const MaritalStatus(id: 3),
  );

  final FilterModel _filterForm = FilterModel(
    beds: 0,
    bathrooms: 0,
    country: Country(id: 854),
    priceType: const PriceType(
      id: 1,
      en: "/month",
      fr: "/mois",
    ),
    features: [],
    types: [],
    categories: [],
    minPrice: 0,
    maxPrice: 10000000,
    currency:
        const Currency(id: 159, currency: "XOF", en: "CFA Franc BCEAO", fr: ""),
    // gender: const Gender(id: 3),
    // occupation: const Job(id: 4),
    // maritalStatus: const MaritalStatus(id: 3),
  );

//Create agency getters'
  String get agencyName => _agencyName;
  String get agencyCountryId => _agencyCountryId;
  String get agencyCountryName => _agencyCountryName;
  String get agencyDescription => _agencyDescription;
  String get agencyPhone => _agencyPhone;
  String get agencyEmail => _agencyEmail;
  String get agencyAdress => _agencyAdress;
  String get agencyTowns => _agencyTowns;
  bool get isOnline => _isOnline;
  HouseModel get houseForm => _houseForm;

  //Add house getters'
  File? get mainImage => _mainImage;
  String get houseType => _houseType;
  int get numberOfBeds => _numberOfBeds;
  int get numberOfBaths => _numberOfBaths;
  String get priceType => _priceType;
  int get price => _price;

  List<dynamic> get countriesList => _countriesList;
  List<dynamic> get houseTypesList => _houseTypesList;
  List<dynamic> get houseCategoriesList => _houseCategoriesList;
  List<dynamic> get priceTypesList => _priceTypesList;
  List<dynamic> get houseFeaturesList => _houseFeaturesList;
  List<dynamic> get gendersList => _gendersList;
  List<dynamic> get jobsList => _jobsList;
  List<dynamic> get maritalStatusList => _maritalStatusList;
  List<dynamic> get currenciesList => _currenciesList;

  void notifyChanges() {
    notifyListeners();
  }

  //Create agency seters
  void setAgencyName(String name) {
    _agencyName = name;
    notifyListeners();
  }

  void setIsOnline(bool status) {
    _isOnline = status;
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

  //End Create agency setters

  //Countries List
  void setCountriesList(List<dynamic> coutries) {
    _countriesList = coutries;
    notifyListeners();
  }

  //House types List
  void setHouseTypesList(List<dynamic> houseTypes) {
    _houseTypesList = houseTypes;
    notifyListeners();
  }

  //House categories List
  void setHouseCategoriesList(List<dynamic> categories) {
    _houseCategoriesList = categories;
    notifyListeners();
  }

  //Price types List
  void setPriceTypesList(List<dynamic> priceTypes) {
    _priceTypesList = priceTypes;
    notifyListeners();
  }

  //House features List
  void setHouseFeaturesList(List<dynamic> houseFeatures) {
    _houseFeaturesList = houseFeatures;
    notifyListeners();
  }

  //House genders List
  void setGendersList(List<dynamic> genders) {
    _gendersList = genders;
    notifyListeners();
  }

  //House jobs List
  void setJobsList(List<dynamic> jobs) {
    _jobsList = jobs;
    notifyListeners();
  }

  //House marital status List
  void setMaritalStatusList(List<dynamic> status) {
    _maritalStatusList = status;
    notifyListeners();
  }

  //House currrencies List
  void setCurrenciesList(List<dynamic> currencies) {
    _currenciesList = currencies;
    notifyListeners();
  }

  void getCountries() {
    List<dynamic> list = getData(keyCountries) ?? _countriesList;
    if (list.length == 1) {
      loadCountries().then((results) {
        if (results.isNotEmpty) {
          setCountriesList(results);
          setCountries(results);
        }
      }, onError: (result) {
        getCountries();
      });
    } else {
      setCountriesList(list);
    }
  }

  void getHouseTypes() {
    List<dynamic> list = getData(keyHouseTypes) ?? _houseTypesList;
    if (list.length == 1) {
      loadHouseTypes().then((results) {
        if (results.isNotEmpty) {
          setHouseTypesList(results);
          setHouseTypes(results);
        }
      }, onError: (result) {
        getHouseTypes();
      });
    } else {
      setHouseTypesList(list);
    }
  }

  void getHouseCategories() {
    List<dynamic> list = getData(keyHouseCategories) ?? _houseCategoriesList;
    if (list.length == 1) {
      loadHouseCategories().then((results) {
        if (results.isNotEmpty) {
          setHouseCategoriesList(results);
          setHouseCategories(results);
        }
      }, onError: (result) {
        getHouseCategories();
      });
    } else {
      setHouseCategoriesList(list);
    }
  }

  void getPriceTypes() {
    List<dynamic> list = getData(keyPriceTypes) ?? _priceTypesList;
    if (list.length == 1) {
      loadPriceTypes().then((results) {
        if (results.isNotEmpty) {
          setPriceTypesList(results);
          setPriceTypes(results);
        }
      }, onError: (result) {
        getPriceTypes();
      });
    } else {
      setPriceTypesList(list);
    }
  }

  void getHouseFeatures() {
    List<dynamic> list = getData(keyHouseFeatures) ?? _houseFeaturesList;
    if (list.isEmpty) {
      loadHouseFeatures().then((results) {
        if (results.isNotEmpty) {
          setHouseFeaturesList(results);
          setHouseFeatures(results);
        }
      }, onError: (result) {
        getHouseFeatures();
      });
    } else {
      setHouseFeaturesList(list);
    }
  }

  void getGenders() {
    List<dynamic> list = getData(keyGenders) ?? _gendersList;
    if (list.length == 1) {
      loadGenders().then((results) {
        if (results.isNotEmpty) {
          setGendersList(results);
          setGenders(results);
        }
      }, onError: (result) {
        getGenders();
      });
    } else {
      setGendersList(list);
    }
  }

  void getJobs() {
    List<dynamic> list = getData(keyJobs) ?? _jobsList;
    if (list.length == 1) {
      loadJobs().then((results) {
        if (results.isNotEmpty) {
          setJobsList(results);
          setJobs(results);
        }
      }, onError: (result) {
        getJobs();
      });
    } else {
      setJobsList(list);
    }
  }

  void getMaritalStatus() {
    List<dynamic> list = getData(keyMaritalStatus) ?? _maritalStatusList;
    if (list.length == 1) {
      loadMaritalStatus().then((results) {
        if (results.isNotEmpty) {
          setMaritalStatusList(results);
          setMaritalStatus(results);
        }
      }, onError: (result) {
        getMaritalStatus();
      });
    } else {
      setMaritalStatusList(list);
    }
  }

  void getCurrencies() {
    List<dynamic> list = getData(keyCurrencies) ?? _currenciesList;
    if (list.length == 1) {
      loadCurrencies().then((results) {
        if (results.isNotEmpty) {
          setCurrenciesList(results);
          setCurrencies(results);
        }
      }, onError: (result) {
        getCurrencies();
      });
    } else {
      setCurrenciesList(list);
    }
  }

  //Add house setters
  void setHouseForm(HouseModel houseForm) {
    _houseForm = houseForm;
  }

  void reSetHouseForm() {
    _houseForm = HouseModel(
      beds: 0,
      bathrooms: 0,
      country: Country(id: 854),
      priceType: const PriceType(id: 1),
      houseType: const HouseType(id: 1),
      houseCategory: const HouseCategory(id: 1),
      price: 0,
      currency: const Currency(id: 159),
      gender: const Gender(id: 3),
      occupation: const Job(id: 4),
      maritalStatus: const MaritalStatus(id: 3),
    );
  }

  Future<bool> checkInternetStatus() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _isOnline = true;
      }
    } on SocketException catch (_) {
      _isOnline = false;
    }
    notifyListeners();
    return _isOnline;
  }
}
