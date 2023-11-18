class HouseCategory {
  final DateTime? createdAt;
  final String? en;
  final String? fr;
  final int? id;

  const HouseCategory({
    this.createdAt,
    this.en,
    this.fr,
    this.id,
  });

  factory HouseCategory.fromMap({required Map<dynamic, dynamic> data}) {
    return HouseCategory(
        createdAt: data["created_at"],
        en: data["en"],
        fr: data["fr"],
        id: int.tryParse(data["id"].toString()));
  }

  @override
  bool operator ==(Object other) {
    return other is HouseCategory &&
        other.runtimeType == runtimeType &&
        other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
