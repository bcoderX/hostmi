class Currency {
  final DateTime? createdAt;
  final String? currency;
  final String? en;
  final String? fr;
  final int? id;

  const Currency({
    this.createdAt,
    this.currency,
    this.en,
    this.fr,
    this.id,
  });

  factory Currency.fromMap({required Map<dynamic, dynamic> data}) {
    return Currency(
        createdAt: data["created_at"],
        currency: data["currency"],
        en: data["en"],
        fr: data["fr"],
        id: data["id"]);
  }

  @override
  bool operator ==(Object other) {
    return other is Currency &&
        other.runtimeType == runtimeType &&
        other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
