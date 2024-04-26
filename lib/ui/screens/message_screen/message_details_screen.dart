import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/api/models/chat_model.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/models/message_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/rest/messages/create_new_chat.dart';
import 'package:hostmi/api/supabase/rest/messages/insert_new_message.dart';
import 'package:hostmi/api/supabase/rest/messages/select_agency_chat.dart';
import 'package:hostmi/api/supabase/rest/messages/select_user_chat.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/screens/loading_page.dart';
import 'package:hostmi/ui/screens/message_screen/widgets/message_bubble_list.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class MessagesDetailsScreen extends StatefulWidget {
  const MessagesDetailsScreen({
    super.key,
    required this.userId,
    required this.agencyId,
    required this.opener,
    this.defaultMessage = "",
    this.onMessageSent,
  });

  final String opener;
  final String userId;
  final String agencyId;
  final String defaultMessage;
  final void Function()? onMessageSent;

  @override
  State<StatefulWidget> createState() {
    return _MessagesDetailsScreenState();
  }
}

class _MessagesDetailsScreenState extends State<MessagesDetailsScreen> {
  finish() {
    // Constant.backToPrev(context);
  }

  DateTime dateTime = DateTime.now();
  EdgeInsets edgeInsets = const EdgeInsets.symmetric(horizontal: 20);
  List<MessageModel> chattingList = [];
  late TextEditingController messageController;
  late Future<ChatModel> _chatDetailsFuture;
  late bool isAgency;
  bool isSending = false;

  @override
  void initState() {
    messageController = TextEditingController();
    messageController.text = widget.defaultMessage;
    isAgency = widget.opener == "agency";
    _chatDetailsFuture = _getChat();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Constant.setupSize(context);
    return WillPopScope(
      onWillPop: () async {
        widget.onMessageSent?.call();
        context.read<HostmiProvider>().initMessenger();
        return true;
      },
      child: FutureBuilder<ChatModel>(
          future: _chatDetailsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData &&
                snapshot.connectionState != ConnectionState.done) {
              return const BallLoadingPage(
                loadingTitle: "Initialisation en cours...",
              );
            } else if (snapshot.hasData) {
              final chat = snapshot.data!;
              if (chat.id != null) {
                return Scaffold(
                    appBar: AppBar(
                      backgroundColor: AppColor.grey,
                      foregroundColor: AppColor.black,
                      elevation: 0.0,
                      title: Text(chat.name!),
                      actions: [
                        CircleAvatar(
                          backgroundImage: chat.imageUrl == null
                              ? null
                              : CachedNetworkImageProvider(chat.imageUrl!),
                          child: chat.imageUrl == null
                              ? Icon(isAgency ? Icons.house : Icons.person)
                              : null,
                        )
                      ],
                    ),
                    body: Padding(
                      padding: edgeInsets,
                      child: Column(children: [
                        Expanded(
                          flex: 1,
                          child: MessageBubbleList(
                            chatId: chat.id!,
                            isAgency: isAgency,
                            userId: chat.currentUserId!,
                            agencyId: chat.agencyId!,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 250,
                                ),
                                child: CustomTextFormField(
                                  shape: TextFormFieldShape.CircleBorder24,
                                  textInputAction: TextInputAction.newline,
                                  textInputType: TextInputType.multiline,
                                  controller: messageController,
                                  hintText: "Ecrire votre message...",
                                  maxLines: null,
                                  maxLength: 1000,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: InkWell(
                                onTap: () async {
                                  setState(() {
                                    isSending = true;
                                  });
                                  final response =
                                      await insertNewMessage(MessageModel(
                                    userId: widget.userId,
                                    senderId: isAgency
                                        ? widget.agencyId
                                        : widget.userId,
                                    receiverId: isAgency
                                        ? widget.userId
                                        : widget.agencyId,
                                    chatId: chat.id,
                                    content: messageController.text,
                                    isFile: false,
                                    fileType: null,
                                  ));
                                  if (response.isSuccess) {
                                    if (response.list!.isNotEmpty) {
                                      messageController.text = "";
                                      _chatDetailsFuture =
                                          _getChat().whenComplete(() {
                                        setState(() {});
                                      });
                                    }
                                  }

                                  setState(() {
                                    isSending = false;
                                  });
                                },
                                child: CircleAvatar(
                                  child: isSending
                                      ? const SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ))
                                      : Icon(
                                          Icons.send_rounded,
                                          size: getVerticalSize(24),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        )
                      ]),
                    ));
              }
            }
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 50.0, horizontal: 10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Une erreur s'est produite"),
                        const SizedBox(height: 20),
                        CustomButton(
                          onTap: () {
                            _chatDetailsFuture = _getChat().whenComplete(() {
                              setState(() {});
                            });
                          },
                          text: "Reessayer",
                          fontStyle: ButtonFontStyle.ManropeBold12WhiteA700_1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Future<ChatModel> _getChat() async {
    DatabaseResponse selectResponse = isAgency
        ? await selectAgencyChat(widget.userId, widget.agencyId)
        : await selectUserChat(widget.userId, widget.agencyId);
    if (selectResponse.isSuccess) {
      if (selectResponse.list!.isNotEmpty) {
        final c = selectResponse.list![0];
        return ChatModel.fromMap(c, isAgency, supabase.auth.currentUser!.id);
      } else {
        final DatabaseResponse creationResponse = await createNewChat(
            ChatModel(userId: widget.userId, agencyId: widget.agencyId));
        if (creationResponse.isSuccess) {
          if (creationResponse.list!.isNotEmpty) {
            final c = creationResponse.list![0];
            return ChatModel.fromMap(
                c, isAgency, supabase.auth.currentUser!.id);
          }
        }
      }
    }
    return ChatModel();
  }
}
