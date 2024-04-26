class UserProfileModel {
  String? id;
  DateTime? updatedAt;
  String? username;
  String? avatarUrl;
  String? website;
  int? jobTitle;
  int? gender;
  DateTime? birthday;
  int? country;
  bool? onlineStatus;
  String? lastname;
  String? firstname;

  UserProfileModel({
    this.id,
    this.updatedAt,
    this.username,
    this.avatarUrl,
    this.website,
    this.jobTitle,
    this.gender,
    this.birthday,
    this.country,
    this.onlineStatus,
    this.lastname,
    this.firstname,
  });

  factory UserProfileModel.fromMap({required Map<String, dynamic> data}) {
    return UserProfileModel(
      id: data["id"],
      updatedAt: DateTime.tryParse(data["updated_at"].toString()),
      username: data["username"],
      avatarUrl: data["avatar_url"],
      website: data["website"],
      jobTitle: int.tryParse(data["job_title"].toString()),
      gender: int.tryParse(data["gender"].toString()),
      birthday: DateTime.tryParse(data["birthday"].toString()),
      country: int.tryParse(data["country"].toString()),
      onlineStatus: data["online_status"],
      lastname: data["lastname"],
      firstname: data["firstname"],
    );
  }
}
