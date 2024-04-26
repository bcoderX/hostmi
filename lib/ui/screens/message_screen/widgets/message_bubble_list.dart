import 'package:flutter/material.dart';
import 'package:hostmi/api/models/message_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/ui/screens/message_screen/widgets/message_bubble.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_button.dart';

class MessageBubbleList extends StatefulWidget {
  const MessageBubbleList({
    super.key,
    required this.chatId,
    required this.isAgency,
    required this.userId,
    required this.agencyId,
  });
  final String chatId;
  final bool isAgency;
  final String userId;
  final String agencyId;

  @override
  State<MessageBubbleList> createState() => _MessageBubbleListState();
}

class _MessageBubbleListState extends State<MessageBubbleList> {
  late Stream<List<Map<String, dynamic>>> _stream;

  List<MessageModel> messages = [];
  @override
  void initState() {
    _stream = supabase
        .from("messages")
        .stream(primaryKey: ["id", "is_deleted", "is_read", "is_received"])
        .eq("chat_id", widget.chatId)
        .order("created_at");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            final response = snapshot.data!;
            if (response.isEmpty) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.comments_disabled_outlined,
                    color: AppColor.primary,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Aucun message"),
                  ),
                ],
              );
            }
                messages = [];
             messages = response.map((e) {
              return MessageModel.fromMap(
                e,
                widget.isAgency,
                widget.userId,
                widget.agencyId,
              );
            }).toList();

            return ListView.builder(
                itemBuilder: (context, index) {
                  // MessageModel modelChat = chattingList[index];

                  return MessageBubble(message: messages[index]);
                },
                itemCount: messages.length,
                shrinkWrap: true,
                reverse: true,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                ));
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.replay_outlined),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    onTap: () {
                      _stream = supabase
                          .from("messages")
                          .stream(primaryKey: [
                            "id",
                            "is_deleted",
                            "is_read",
                            "is_received"
                          ])
                          .eq("chat_id", widget.chatId)
                          .order("created_at");
                    },
                    text: "Recharger",
                    fontStyle: ButtonFontStyle.ManropeBold16WhiteA700_1,
                  ))
            ],
          );
        });
  }
}
