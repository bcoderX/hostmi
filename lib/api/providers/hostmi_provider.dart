import 'dart:io';
import 'package:hostmi/api/utils/check_connection_and_do.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/api/models/country_model.dart';
import 'package:hostmi/api/models/currency.dart';
import 'package:hostmi/api/models/filter_model.dart';
import 'package:hostmi/api/models/gender.dart';
import 'package:hostmi/api/models/hostmi_update_model.dart';
import 'package:hostmi/api/models/house_category.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/models/house_type.dart';
import 'package:hostmi/api/models/job.dart';
import 'package:hostmi/api/models/marital_status.dart';
import 'package:hostmi/api/models/price_type.dart';
import 'package:hostmi/api/supabase/rest/utils/load_curencies.dart';
import 'package:hostmi/api/supabase/rest/utils/load_genders.dart';
import 'package:hostmi/api/supabase/rest/utils/load_house_categories.dart';
import 'package:hostmi/api/supabase/rest/utils/load_house_features.dart';
import 'package:hostmi/api/supabase/rest/utils/load_house_types.dart';
import 'package:hostmi/api/supabase/rest/utils/load_jobs.dart';
import 'package:hostmi/api/supabase/rest/utils/load_marital_status.dart';
import 'package:hostmi/api/supabase/rest/utils/load_price_types.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/api/utils/parse_string_to_bool.dart';
import '../hostmi_local_database/hostmi_local_database.dart';
import '../supabase/rest/utils/load_countries.dart';

class HostmiProvider with ChangeNotifier {
  //updates check
  bool _hasCheckedUpdates = false;
  bool _hasCheckedDbUpdates = false;
  bool _hasUpdates = false;
  final bool _hasDbUpdates = false;
  final List<bool> _updateCount = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  HostmiUpdate? _update;
  // DatabaseUpdateModel? _dbUpdate;
  bool _isLoggedIn = supabase.auth.currentUser != null;
  bool _isMessengerIniated = false;
  //Login Variables
  bool canResendSMS = true;
  int smsSentCount = 0;

  //Unread messages variables
  int unreadUserCount = 0;
  int unreadAgencyCount = 0;
  //Create agency variables
  String _agencyName = "";
  String _agencyCountryId = "854";
  String _agencyCountryName = "Burkina Faso";
  String _agencyDescription = "";
  String _agencyPhone = "";
  String _agencyWhatsapp = "";
  String _agencyEmail = "";
  String _agencyAdress = "";
  String _agencyTowns = "";
  List<dynamic> _countriesList = getData(keyCountries) ??
      [
        {
          "id": "854",
          "en": "Burkina Faso",
          "fr": "Burkina Faso",
        }
      ];

  List<dynamic> _houseTypesList = getData(keyHouseTypes) ??
      [
        {
          "id": 1,
          "en": "Simple house",
          "fr": "Maison simple",
        }
      ];
  List<dynamic> _houseCategoriesList = getData(keyHouseCategories) ??
      [
        {
          "id": "1",
          "en": "Unique house",
          "fr": "Cours unique",
        }
      ];
  List<dynamic> _priceTypesList = getData(keyPriceTypes) ??
      [
        {
          "id": 1,
          "en": "monthly",
          "fr": "par mois",
        }
      ];

  List<dynamic> _gendersList = getData(keyGenders) ??
      [
        {
          "id": 3,
          "en": "Any",
          "fr": "N'importe lequel",
        }
      ];
  List<dynamic> _jobsList = getData(keyJobs) ??
      [
        {
          "id": 4,
          "en": "Any",
          "fr": "N'importe lequel",
        }
      ];
  List<dynamic> _maritalStatusList = getData(keyMaritalStatus) ??
      [
        {
          "id": 3,
          "en": "Any",
          "fr": "N'importe lequel",
        }
      ];

  List<dynamic> _currenciesList = getData(keyCurrencies) ??
      [
        {
          "id": 159,
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

  FilterModel? _filterForm;

//Create agency getters'
  String get agencyName => _agencyName;
  String get agencyCountryId => _agencyCountryId;
  String get agencyCountryName => _agencyCountryName;
  String get agencyDescription => _agencyDescription;
  String get agencyPhone => _agencyPhone;
  String get agencyWhatsapp => _agencyWhatsapp;
  String get agencyEmail => _agencyEmail;
  String get agencyAdress => _agencyAdress;
  String get agencyTowns => _agencyTowns;
  bool get isOnline => _isOnline;
  bool get isLoggedIn => _isLoggedIn;
  bool get isMessengerIniated => _isMessengerIniated;

  HouseModel get houseForm => _houseForm;
  FilterModel get filterForm {
    _filterForm ??= FilterModel(
      beds: -1,
      bathrooms: -1,
      country: Country(id: 854, en: "Burkina Faso", fr: "Burkina Faso"),
      priceType: const PriceType(id: 1, en: "/month", fr: "/mois"),
      features: [],
      types: [const HouseType(id: 1, en: "Simple house", fr: "Maison simple")],
      categories: [
        const HouseCategory(id: 1, fr: "Cours unique", en: "Unique house")
      ],
      minPrice: 0,
      maxPrice: 10000000,
      currency: const Currency(currency: "XOF", id: 159),
      genders: gendersList.map((e) => Gender.fromMap(data: e)).toList(),
      occupations: jobsList.map((e) => Job.fromMap(data: e)).toList(),
      maritalStatus:
          maritalStatusList.map((e) => MaritalStatus.fromMap(data: e)).toList(),
      quarters: ["%%"],
      sectors: [],
      cities: ["%%"],
    );

    return _filterForm!;
  }

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
  //updates check
  bool get hasCheckedUpdates => _hasCheckedUpdates;
  bool get hasCheckedDbUpdates => _hasCheckedDbUpdates;
  bool get hasUpdates => _hasUpdates;
  List<bool> get updateCount => _updateCount;
  bool get hasDbUpdates => _hasDbUpdates;
  HostmiUpdate? get update => _update;

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

  void setAgencyWhatsApp(String phone) {
    _agencyWhatsapp = phone;
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

  //updates check
  void setHasCheckedUpdates(bool hasChecked) {
    _hasCheckedUpdates = hasChecked;
    notifyListeners();
  }

  //updates check
  void setHasCheckedDbUpdates(bool hasChecked) {
    _hasCheckedDbUpdates = hasChecked;
    notifyListeners();
  }

  void setHasUpdates(bool hasUp) {
    _hasUpdates = hasUp;
    notifyListeners();
  }

  void setUpdate(HostmiUpdate up) {
    _update = up;
    notifyListeners();
  }

  void setIsLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void set(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void setIsMessengerInitiated(bool value) {
    _isMessengerIniated = value;
    notifyListeners();
  }

  void getCountries({bool forceUpdate = false, String? version}) {
    List<dynamic> list = getData(keyCountries) ?? _countriesList;
    if (list.length == 1 || forceUpdate) {
      loadCountries().then((results) {
        if (results.isNotEmpty) {
          setCountriesList(results);
          setCountries(results);
          if (forceUpdate) {
            _updateCount[0] = true;
            if (!_updateCount.contains(false)) {
              setCurrentDbVersion(version!);
            }
          }
        }
      }, onError: (result) {
        getCountries(forceUpdate: forceUpdate, version: version);
      });
    } else {
      setCountriesList(list);
    }
  }

  void getHouseTypes({bool forceUpdate = false, String? version}) {
    List<dynamic> list = getData(keyHouseTypes) ?? _houseTypesList;
    if (list.length == 1 || forceUpdate) {
      loadHouseTypes().then((results) {
        if (results.isNotEmpty) {
          setHouseTypesList(results);
          setHouseTypes(results);
          if (forceUpdate) {
            _updateCount[1] = true;
            if (!_updateCount.contains(false)) {
              setCurrentDbVersion(version!);
            }
          }
        }
      }, onError: (result) {
        getHouseTypes(forceUpdate: forceUpdate, version: version);
      });
    } else {
      setHouseTypesList(list);
    }
  }

  void getHouseCategories({bool forceUpdate = false, String? version}) {
    List<dynamic> list = getData(keyHouseCategories) ?? _houseCategoriesList;
    if (list.length == 1 || forceUpdate) {
      loadHouseCategories().then((results) {
        if (results.isNotEmpty) {
          setHouseCategoriesList(results);
          setHouseCategories(results);
          if (forceUpdate) {
            _updateCount[2] = true;
            if (!_updateCount.contains(false)) {
              setCurrentDbVersion(version!);
            }
          }
        }
      }, onError: (result) {
        getHouseCategories(forceUpdate: forceUpdate, version: version);
      });
    } else {
      setHouseCategoriesList(list);
    }
  }

  void getPriceTypes({bool forceUpdate = false, String? version}) {
    List<dynamic> list = getData(keyPriceTypes) ?? _priceTypesList;
    if (list.length == 1 || forceUpdate) {
      loadPriceTypes().then((results) {
        if (results.isNotEmpty) {
          setPriceTypesList(results);
          setPriceTypes(results);
          if (forceUpdate) {
            _updateCount[3] = true;
            if (!_updateCount.contains(false)) {
              setCurrentDbVersion(version!);
            }
          }
        }
      }, onError: (result) {
        getPriceTypes(forceUpdate: forceUpdate, version: version);
      });
    } else {
      setPriceTypesList(list);
    }
  }

  void getHouseFeatures({bool forceUpdate = false, String? version}) {
    List<dynamic> list = getData(keyHouseFeatures) ?? _houseFeaturesList;
    if (list.isEmpty || forceUpdate) {
      loadHouseFeatures().then((results) {
        if (results.isNotEmpty) {
          setHouseFeaturesList(results);
          setHouseFeatures(results);
          if (forceUpdate) {
            _updateCount[4] = true;
            if (!_updateCount.contains(false)) {
              setCurrentDbVersion(version!);
            }
          }
        }
      }, onError: (result) {
        getHouseFeatures(forceUpdate: forceUpdate, version: version);
      });
    } else {
      setHouseFeaturesList(list);
    }
  }

  void getGenders({bool forceUpdate = false, String? version}) {
    List<dynamic> list = getData(keyGenders) ?? _gendersList;
    if (list.length == 1 || forceUpdate) {
      loadGenders().then((results) {
        if (results.isNotEmpty) {
          setGendersList(results);
          setGenders(results);
          if (forceUpdate) {
            _updateCount[5] = true;
            if (!_updateCount.contains(false)) {
              setCurrentDbVersion(version!);
            }
          }
        }
      }, onError: (result) {
        getGenders(forceUpdate: forceUpdate, version: version);
      });
    } else {
      setGendersList(list);
    }
  }

  void getJobs({bool forceUpdate = false, String? version}) {
    List<dynamic> list = getData(keyJobs) ?? _jobsList;
    if (list.length == 1 || forceUpdate) {
      loadJobs().then((results) {
        if (results.isNotEmpty) {
          setJobsList(results);
          setJobs(results);
          if (forceUpdate) {
            _updateCount[6] = true;
            if (!_updateCount.contains(false)) {
              setCurrentDbVersion(version!);
            }
          }
        }
      }, onError: (result) {
        getJobs(forceUpdate: forceUpdate, version: version);
      });
    } else {
      setJobsList(list);
    }
  }

  void getMaritalStatus({bool forceUpdate = false, String? version}) {
    List<dynamic> list = getData(keyMaritalStatus) ?? _maritalStatusList;
    if (list.length == 1 || forceUpdate) {
      loadMaritalStatus().then((results) {
        if (results.isNotEmpty) {
          setMaritalStatusList(results);
          setMaritalStatus(results);
          if (forceUpdate) {
            _updateCount[7] = true;
            if (!_updateCount.contains(false)) {
              setCurrentDbVersion(version!);
            }
          }
        }
      }, onError: (result) {
        getMaritalStatus(forceUpdate: forceUpdate, version: version);
      });
    } else {
      setMaritalStatusList(list);
    }
  }

  void getCurrencies({bool forceUpdate = false, String? version}) {
    List<dynamic> list = getData(keyCurrencies) ?? _currenciesList;
    if (list.length == 1 || forceUpdate) {
      loadCurrencies().then((results) {
        if (results.isNotEmpty) {
          setCurrenciesList(results);
          setCurrencies(results);
          if (forceUpdate) {
            _updateCount[8] = true;
            if (!_updateCount.contains(false)) {
              setCurrentDbVersion(version!);
            }
          }
        }
      }, onError: (result) {
        getCurrencies(forceUpdate: forceUpdate, version: version);
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

  void initMessenger() {
    try {
      if (_isLoggedIn && !_isMessengerIniated) {
        checkConnectionAndDo(() {
          supabase
              .from("messages")
              .stream(
                primaryKey: ["id", "is_deleted", "is_read", "is_received"],
              )
              .eq(
                "receiver_id",
                supabase.auth.currentUser!.id,
              )
              .order("created_at")
              .listen((event) {
                unreadUserCount = event
                    .where((element) =>
                        !parseToBool(element["is_read"].toString()))
                    .toList()
                    .length;
                notifyListeners();
                debugPrint(event.length.toString());
              }, onError: (error) {
                setIsMessengerInitiated(false);
              });
          setIsMessengerInitiated(true);
        });
      }
    } catch (e) {
      setIsMessengerInitiated(false);
    }

    getAgencyDetails().then((value) {
      if (value.isNotEmpty) {
        if (value[0] != null) {
          supabase
              .from("messages")
              .stream(
                primaryKey: ["id", "is_deleted", "is_read", "is_received"],
              )
              .eq(
                "receiver_id",
                value[0]!.id,
              )
              .order("created_at")
              .listen((event) {
                unreadAgencyCount = event
                    .where((element) =>
                        !parseToBool(element["is_read"].toString()))
                    .toList()
                    .length;
                notifyListeners();
                debugPrint(event.length.toString());
              });
        }
      }
    });
  }

  void resetFilters() {
    _filterForm = FilterModel(
      beds: -1,
      bathrooms: -1,
      country: Country(id: 854, en: "Burkina Faso", fr: "Burkina Faso"),
      priceType: const PriceType(id: 1, en: "/month", fr: "/mois"),
      features: [],
      types: [const HouseType(id: 1, en: "Simple house", fr: "Maison simple")],
      categories: [
        const HouseCategory(id: 1, fr: "Cours unique", en: "Unique house")
      ],
      minPrice: 0,
      maxPrice: 10000000,
      currency: const Currency(currency: "XOF", id: 159),
      genders: gendersList.map((e) => Gender.fromMap(data: e)).toList(),
      occupations: jobsList.map((e) => Job.fromMap(data: e)).toList(),
      maritalStatus:
          maritalStatusList.map((e) => MaritalStatus.fromMap(data: e)).toList(),
      quarters: ["%%"],
      sectors: [],
      cities: ["%%"],
    );
    notifyListeners();
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
