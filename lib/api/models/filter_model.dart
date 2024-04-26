import 'package:hostmi/api/models/country_model.dart';
import 'package:hostmi/api/models/currency.dart';
import 'package:hostmi/api/models/gender.dart';
import 'package:hostmi/api/models/house_category.dart';
import 'package:hostmi/api/models/house_features.dart';
import 'package:hostmi/api/models/house_type.dart';
import 'package:hostmi/api/models/job.dart';
import 'package:hostmi/api/models/marital_status.dart';
import 'package:hostmi/api/models/price_type.dart';
import 'package:numeral/numeral.dart';

class FilterModel {
  FilterModel({
    required this.genders,
    required this.occupations,
    required this.maritalStatus,
    required this.features,
    required this.categories,
    required this.types,
    required this.quarters,
    required this.priceType,
    this.isAvailable,
    this.minPrice,
    this.maxPrice,
    required this.beds,
    required this.bathrooms,
    required this.sectors,
    required this.cities,
    required this.country,
    this.longitude,
    this.latitude,
    required this.currency,
  });
  PriceType priceType;
  double? minPrice;
  double? maxPrice;
  Currency currency;
  int beds;
  int bathrooms;
  List<int> sectors;
  List<String> quarters;
  List<String> cities;
  Country country;
  double? longitude;
  double? latitude;
  List<HouseFeatures> features;
  List<HouseCategory> categories;
  List<HouseType> types;
  List<Gender> genders;
  List<Job> occupations;
  List<MaritalStatus> maritalStatus;
  bool? isAvailable;

  factory FilterModel.fromMap(Map<String, dynamic> data) {
    // print(data["features"][0].runtimeType);
    return FilterModel(
      priceType: data["price_types"],
      minPrice: double.tryParse(data["minPrice"].toString()),
      maxPrice: double.tryParse(data["maxPrice"].toString()),
      currency: data["currencies"],
      beds: data["bedrooms"],
      bathrooms: data["bathrooms"],
      sectors: data["sectors"],
      quarters: data["quarters"],
      cities: data["cities"],
      country: data["country"],
      longitude: double.tryParse(data["longitude"].toString()),
      latitude: double.tryParse(data["latitude"].toString()),
      features: data["features"],
      categories: data["categories"],
      types: data["types"],
      genders: data["genders"],
      occupations: data["occupations"],
      maritalStatus: data["maritalStatus"],
    );
  }

  String get shortMinPrice => minPrice!.numeral();
  String get shortMaxPrice => maxPrice!.numeral();

//Getting the ids to use in the filters query
  List<int> get featuresIds => features.map((e) => e.id!).toList();
  List<int> get categoriesIds => categories.map((e) => e.id!).toList();
  List<int> get typesIds => types.map((e) => e.id).toList();
  List<int> get gendersIds => genders.map((e) => e.id!).toList();
  List<int> get occupationsIds => occupations.map((e) => e.id!).toList();
  List<int> get maritalStatusIds => maritalStatus.map((e) => e.id!).toList();
}
