import 'package:hive/hive.dart';

part 'agency_model.g.dart';

@HiveType(typeId: 3)
class AgencyModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final DateTime? createdAt;
  @HiveField(2)
  final DateTime? updatedAt;
  @HiveField(3)
  final int? countryId;
  @HiveField(4)
  final String? name;
  @HiveField(5)
  final String? phoneNumber;
  @HiveField(6)
  final String? email;
  @HiveField(7)
  final String? legalReferences;
  @HiveField(8)
  final String? cities;
  @HiveField(9)
  final String? description;
  @HiveField(10)
  final String? address;
  @HiveField(11)
  final String? longitude;
  @HiveField(12)
  final String? latitude;
  @HiveField(13)
  final bool? isBlocked;
  @HiveField(14)
  final bool? isVerified;
  @HiveField(15)
  final bool? isDeleted;
  @HiveField(16)
  final String? createdBy;
  @HiveField(17)
  final String? coverImageUrl;
  @HiveField(18)
  final String? profileImageUrl;
  @HiveField(19)
  final String? website;
  @HiveField(20)
  final String? whatsapp;

  AgencyModel(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.countryId,
      this.name,
      this.phoneNumber,
      this.whatsapp,
      this.email,
      this.legalReferences,
      this.cities,
      this.description,
      this.address,
      this.longitude,
      this.latitude,
      this.isBlocked,
      this.isDeleted,
      this.isVerified,
      this.createdBy,
      this.coverImageUrl,
      this.profileImageUrl,
      this.website});
  factory AgencyModel.fromMap(Map<String, dynamic> data) {
    return AgencyModel(
      id: data["id"],
      createdAt: DateTime.tryParse(data["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(data["updated_at"] ?? ""),
      countryId: data["country_id"],
      name: data["name"],
      phoneNumber: data["phone_number"],
      whatsapp: data["whatsapp"],
      email: data["email"],
      legalReferences: data["legal_references"],
      cities: data["cities"],
      description: data["description"],
      address: data["address"],
      longitude: data["longitude"],
      latitude: data["latitude"],
      isBlocked: data["is_blocked"],
      isDeleted: data["is_deleted"],
      isVerified: data["is_verified"],
      createdBy: data["created_by"],
      coverImageUrl: data["cover_image_url"],
      profileImageUrl: data["profile_image_url"],
      website: data["website"],
    );
  }
}
