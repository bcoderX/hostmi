import 'package:hive/hive.dart';

part 'country_model.g.dart';

@HiveType(typeId: 2)
class Country{
  Country({required this.id,  this.alpha2,  this.en, this.fr});
  factory Country.fromMap(Map<String, dynamic> data){
    return Country(id: int.parse(data["id"].toString()), alpha2:data["alpha2"], en: data["en"], fr: data["fr"]);
  }

  @HiveField(0)
  int id;

  @HiveField(1)
  String? alpha2;

  @HiveField(2)
  String? en;

  @HiveField(3)
  String? fr;

  @override
  bool operator ==(Object other) {
    return other is Country && other.runtimeType == runtimeType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}