import 'package:hostmi/api/models/currency.dart';
import 'package:hostmi/api/models/gender.dart';
import 'package:hostmi/api/models/job.dart';
import 'package:hostmi/api/models/marital_status.dart';
import 'package:hostmi/api/models/price_type.dart';

import 'country_model.dart';

class FilterModel {
  FilterModel({
    this.gender,
    this.occupation,
    this.maritalStatus,
    this.quarter,
    required this.features,
    required this.categories,
    required this.types,
    this.priceType,
    this.isAvailable,
    this.minPrice,
    this.maxPrice,
    this.beds,
    this.bathrooms,
    this.sector,
    this.city,
    this.country,
    this.longitude,
    this.latitude,
    this.currency,
  });
  PriceType? priceType;
  double? minPrice;
  double? maxPrice;
  Currency? currency;
  int? beds;
  int? bathrooms;
  int? sector;
  String? quarter;
  String? city;
  Country? country;
  double? longitude;
  double? latitude;
  List<int> features;
  List<int> categories;
  List<int> types;
  Gender? gender;
  Job? occupation;
  MaritalStatus? maritalStatus;
  bool? isAvailable;

  factory FilterModel.fromMap(Map<String, dynamic> data) {
    // print(data["features"][0].runtimeType);
    return FilterModel(
      priceType: PriceType.fromMap(data: data["price_types"]),
      minPrice: double.tryParse(data["minPrice"].toString()),
      maxPrice: double.tryParse(data["maxPrice"].toString()),
      currency: Currency.fromMap(data: data["currencies"]),
      beds: data["bedrooms"],
      bathrooms: data["bathrooms"],
      sector: data["sector"],
      quarter: data["quarter"],
      city: data["city"],
      country: data["country"],
      longitude: double.tryParse(data["longitude"].toString()),
      latitude: double.tryParse(data["latitude"].toString()),
      features: data["features"],
      categories: data["categories"],
      types: data["types"],
    );
  }
}
