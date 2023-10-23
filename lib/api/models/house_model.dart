import 'dart:io';

class HouseModel {
  HouseModel(
      {this.gender,
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
      this.imagesDescriptions,
      this.currency});
  final DateTime? createdAt;
  File? mainImage;
  int? houseType;
  int? houseCategory;
  int? priceType;
  int? price;
  int? currency;
  int? beds;
  int? bathrooms;
  int? sector;
  String? quarter;
  String? city;
  int? country;
  String? fullAddress;
  double? longitude;
  double? latitude;
  List<int>? features;
  String? description;
  List<File?>? images;
  List<String>? imagesDescriptions;
  int? gender;
  int? occupation;
  int? maritalStatus;
  int? stars;
  bool? isFavorite;
  bool? isAvailable;
}
