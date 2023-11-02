class HouseType{
  final DateTime? createdAt;
  final String? en;
  final String? fr;
  final int id;

  const HouseType({
    this.createdAt,
    this.en,
    this.fr,
    required this.id,
  });

  factory HouseType.fromMap({required Map<dynamic, dynamic> data}){
    return HouseType(
        createdAt: data["created_at"],
        en: data["en"],
        fr: data["fr"],
        id: int.parse(data["id"].toString())
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HouseType && other.runtimeType == runtimeType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}