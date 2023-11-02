class Job{
  final DateTime? createdAt;
  final String? en;
  final String? fr;
  final int? id;

  const Job({
    this.createdAt,
    this.en,
    this.fr,
    this.id,
  });

  factory Job.fromMap({required Map<dynamic, dynamic> data}){
    return Job(
        createdAt: data["created_at"],
        en: data["en"],
        fr: data["fr"],
        id:  int.parse(data["id"].toString())
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Job && other.runtimeType == runtimeType && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}