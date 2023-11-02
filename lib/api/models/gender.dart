class Gender{
  final DateTime? createdAt;
  final String? en;
  final String? fr;
  final int? id;

  const Gender({
    this.createdAt,
    this.en,
    this.fr,
    this.id,
  });

  factory Gender.fromMap({required Map<dynamic, dynamic> data}){
    return Gender(
        createdAt: data["created_at"],
        en: data["en"],
        fr: data["fr"],
        id:  int.parse(data["id"].toString())
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Gender && other.runtimeType == runtimeType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}