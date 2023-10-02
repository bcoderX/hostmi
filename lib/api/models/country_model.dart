import 'package:hive/hive.dart';

part 'country_model.g.dart';

@HiveType(typeId: 2)
class Country{
  Country({required this.id, required this.alpha2, required this.en, required this.fr});
  factory Country.fromMap(Map<String, dynamic> data){
    return Country(id: data["id"].toString(), alpha2:data["alpha2"], en: data["en"], fr: data["fr"]);
  }

  @HiveField(0)
  String id;

  @HiveField(1)
  String alpha2;

  @HiveField(2)
  String en;

  @HiveField(3)
  String fr;
}