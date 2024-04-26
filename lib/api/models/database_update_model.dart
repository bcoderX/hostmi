class DatabaseUpdateModel {
  final DateTime? createdAt;
  final String? version;
  final String? id;

  const DatabaseUpdateModel({
    this.createdAt,
    this.version,
    this.id,
  });

  factory DatabaseUpdateModel.fromMap({required Map<dynamic, dynamic> data}) {
    return DatabaseUpdateModel(
      createdAt: DateTime.tryParse(data["created_at"].toString()),
      version: data["version"],
      id: data["id"],
    );
  }
}
