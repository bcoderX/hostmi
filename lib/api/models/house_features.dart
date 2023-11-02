import 'package:hostmi/api/models/currency.dart';

class HouseFeatures{
  final DateTime? createdAt;
  final String? en;
  final String? fr;
  final int? id;

  const HouseFeatures({
    this.createdAt,
    this.en,
    this.fr,
    this.id,
  });

  factory HouseFeatures.fromMap({required Map<dynamic, dynamic> data}){
    return HouseFeatures(
        createdAt: data["created_at"],
        en: data["en"],
        fr: data["fr"],
        id:  data["id"]
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Currency && other.runtimeType == runtimeType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}