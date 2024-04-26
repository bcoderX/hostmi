import 'package:hostmi/api/utils/parse_string_to_bool.dart';

class MessageModel {
  MessageModel({
    this.id,
    this.createdAt,
    this.chatId,
    this.senderId,
    this.receiverId,
    this.content,
    this.isFile,
    this.fileType,
    this.isReceived,
    this.isRead,
    this.receivedDate,
    this.readDate,
    this.isDeleted,
    this.isAgencyScreen,
    this.agencyId,
    this.userId,
  });

  String? id;
  DateTime? createdAt;
  String? chatId;
  String? senderId;
  String? receiverId;
  String? content;
  bool? isFile;
  String? fileType;
  bool? isReceived;
  bool? isRead;
  DateTime? receivedDate;
  DateTime? readDate;
  bool? isDeleted;
  bool? isAgencyScreen;
  String? agencyId;
  String? userId;

  factory MessageModel.fromMap(Map<String, dynamic> data, bool isAgency,
      String userId, String agencyId) {
    return MessageModel(
      id: data["id"],
      createdAt: DateTime.tryParse(data["created_at"].toString()),
      chatId: data["chat_id"],
      senderId: data["sender_id"],
      receiverId: data["receiver_id"],
      content: data["content"],
      isFile: parseToBool(data["is_file"].toString()),
      fileType: data["file_type"],
      isReceived: parseToBool(data["is_received"].toString()),
      isRead: parseToBool(data["is_read"].toString()),
      receivedDate: DateTime.tryParse(data["received_date"].toString()),
      readDate: DateTime.tryParse(data["read_date"].toString()),
      isDeleted: parseToBool(data["is_deleted"].toString()),
      isAgencyScreen: isAgency,
      agencyId: agencyId,
      userId: userId,
    );
  }

  bool get isSender =>
      isAgencyScreen! ? agencyId == senderId : userId == senderId;
}
