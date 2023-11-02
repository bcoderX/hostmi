class PriceType{
  final DateTime? createdAt;
  final String? en;
  final String? fr;
  final int? id;

  const PriceType({
    this.createdAt,
    this.en,
    this.fr,
    this.id,
  });

  factory PriceType.fromMap({required Map<dynamic, dynamic> data}){
    return PriceType(
        createdAt: data["created_at"],
        en: data["en"],
        fr: data["fr"],
        id:  data["id"]
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PriceType && other.runtimeType == runtimeType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}