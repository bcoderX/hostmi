class ReviewModel {
  final String? id;
  final DateTime? createdAt;
  final String? userId;
  final String? agencyId;
  final double? stars;
  final String? comment;
  final String? isAnonyme;
  final String? lastname;
  final String? firstname;
  final String? avatarUrl;

  const ReviewModel({
    this.id,
    this.createdAt,
    this.userId,
    this.agencyId,
    this.stars,
    this.comment,
    this.isAnonyme,
    this.lastname,
    this.firstname,
    this.avatarUrl,
  });

  factory ReviewModel.fromMap({required Map<dynamic, dynamic> data}) {
    return ReviewModel(
      id: data["id"].toString(),
      createdAt: DateTime.parse(data["created_at"]),
      userId: data["user_id"],
      agencyId: data["agency_id"],
      stars: double.tryParse(data["stars"].toString()),
      comment: data["comment"],
      lastname: data["profiles"]["lastname"] ?? "",
      avatarUrl: data["profiles"]["avatar_url"],
      firstname: data["profiles"]["firstname"] ?? "",
    );
  }

  String get fullName => "$firstname  $lastname";
}
