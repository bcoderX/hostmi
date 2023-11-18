import 'dart:io';

import 'package:hostmi/api/models/currency.dart';
import 'package:hostmi/api/models/gender.dart';
import 'package:hostmi/api/models/house_type.dart';
import 'package:hostmi/api/models/job.dart';
import 'package:hostmi/api/models/marital_status.dart';
import 'package:hostmi/api/models/price_type.dart';
import 'package:intl/intl.dart';

import 'country_model.dart';
import 'house_category.dart';

class HouseModel {
  HouseModel(
      {this.id,
      this.gender,
      this.occupation,
      this.maritalStatus,
      this.createdAt,
      this.quarter,
      this.features,
      this.houseType,
      this.houseCategory,
      this.priceType,
      this.isAvailable,
      this.mainImage,
      this.mainImageUrl,
      this.price,
      this.beds,
      this.bathrooms,
      this.fullAddress,
      this.sector,
      this.city,
      this.country,
      this.longitude,
      this.latitude,
      this.description,
      this.stars,
      this.isFavorite,
      this.images,
      this.imagesUrl,
      this.imagesDescriptions,
      this.currency,
      this.agencyId});
  DateTime? createdAt;
  String? id;
  File? mainImage;
  String? mainImageUrl;
  HouseType? houseType;
  HouseCategory? houseCategory;
  PriceType? priceType;
  double? price;
  Currency? currency;
  int? beds;
  int? bathrooms;
  int? sector;
  String? quarter;
  String? city;
  Country? country;
  String? fullAddress;
  double? longitude;
  double? latitude;
  List<dynamic>? features;
  String? description;
  List<File?>? images;
  List<dynamic>? imagesUrl;
  List<String>? imagesDescriptions;
  String? agencyId;
  Gender? gender;
  Job? occupation;
  MaritalStatus? maritalStatus;
  int? stars;
  bool? isFavorite;
  bool? isAvailable;

  String get formattedPrice => NumberFormat.currency(
          locale: "fr_FR",
          name: currency!.currency == "XOF" || currency!.currency == "XAF"
              ? "F CFA"
              : currency!.currency)
      .format(price);

  factory HouseModel.fromMap(Map<String, dynamic> data) {
    // print(data["features"][0].runtimeType);
    return HouseModel(
      id: data["id"],
      createdAt: DateTime.parse(data["created_at"]),
      mainImageUrl: data["houses_pictures"].length > 0
          ? data["houses_pictures"][0]["image_url"]
          : null,
      houseType: HouseType.fromMap(data: data["house_types"]),
      houseCategory: HouseCategory.fromMap(data: data["house_categories"]),
      priceType: PriceType.fromMap(data: data["price_types"]),
      price: double.tryParse(data["price"].toString()),
      currency: Currency.fromMap(data: data["currencies"]),
      beds: data["bedrooms"],
      bathrooms: data["bathrooms"],
      sector: data["sector"],
      quarter: data["quarter"],
      city: data["city"],
      country: Country.fromMap(data["countries"]),
      fullAddress: data["full_address"],
      longitude: double.tryParse(data["longitude"].toString()),
      latitude: double.tryParse(data["latitude"].toString()),
      description: data["description"],
      imagesUrl: data["houses_pictures"],
      features: data["features"],
      agencyId: data["agency_id"],
    );
  }
}
