import 'package:hostmi/api/models/message_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';

class ChatModel {
  ChatModel({
    this.id,
    this.createdAt,
    this.agencyId,
    this.userId,
    this.currentUserId,
    this.lastMessage,
    this.isAgencyScreen,
    this.imageUrl,
    this.name,
  });

  String? id;
  DateTime? createdAt;
  String? agencyId;
  String? userId;
  String? currentUserId;
  MessageModel? lastMessage;
  bool? isAgencyScreen;
  String? imageUrl;
  String? name;

  factory ChatModel.fromMap(
      Map<String, dynamic> data, bool isAgency, String currentUser) {
    bool isList = data["messages"].runtimeType == List;
    return ChatModel(
      id: data["id"],
      name: isAgency
          ? "${data["profiles"]["firstname"]} ${data["profiles"]["lastname"]}"
          : data["agencies"]["name"],
      imageUrl: isAgency
          ? data["profiles"]["avatar_url"] == null
              ? null
              : supabase.storage
                  .from(isAgency ? "profiles" : "agencies")
                  .getPublicUrl(data["profiles"]["avatar_url"])
          : data["agencies"]["profile_image_url"] == null
              ? null
              : supabase.storage
                  .from(isAgency ? "profiles" : "agencies")
                  .getPublicUrl(data["agencies"]["profile_image_url"]),
      agencyId: data["agency_id"],
      userId: data["user_id"],
      createdAt: DateTime.tryParse(data["created_at"].toString()),
      lastMessage: isList
          ? data["messages"].isNotEmpty
              ? MessageModel.fromMap(data["messages"][0], isAgency,
                  data["user_id"], data["agency_id"])
              : null
          : data["messages"] == null
              ? null
              : MessageModel.fromMap(data["messages"][0], isAgency,
                  data["user_id"], data["agency_id"]),
      currentUserId: currentUser,
    );
  }

  bool get isSender => isAgencyScreen!
      ? lastMessage!.agencyId == agencyId
      : lastMessage!.userId == userId;
}
