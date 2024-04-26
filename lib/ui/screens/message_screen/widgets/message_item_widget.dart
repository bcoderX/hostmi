import 'package:flutter/material.dart';
import 'package:hostmi/api/models/chat_model.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/supabase/rest/messages/select_unread_count_messages.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:numeral/numeral.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class MessageItemWidget extends StatefulWidget {
  const MessageItemWidget(
      {super.key, this.onTaptf, required this.chat, required this.receiverId});
  final ChatModel chat;
  final String receiverId;

  final VoidCallback? onTaptf;

  @override
  State<MessageItemWidget> createState() => _MessageItemWidgetState();
}

class _MessageItemWidgetState extends State<MessageItemWidget> {
  late Future<DatabaseResponse> _getUnread;
  @override
  void initState() {
    _getUnread = selectUnreadCountMessages(widget.chat.id!, widget.receiverId);
    // setLocaleMessages("fr", FrMessages());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTaptf?.call();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: getSize(
              48,
            ),
            width: getSize(
              48,
            ),
            margin: getMargin(
              top: 1,
              bottom: 2,
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CustomImageView(
                  url: widget.chat.imageUrl,
                  imagePath: widget.chat.imageUrl == null
                      ? ImageConstant.imageNotFound
                      : null,
                  height: getSize(
                    48,
                  ),
                  width: getSize(
                    48,
                  ),
                  radius: BorderRadius.circular(
                    getHorizontalSize(
                      24,
                    ),
                  ),
                  alignment: Alignment.center,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: getSize(
                      12,
                    ),
                    width: getSize(
                      12,
                    ),
                    decoration: BoxDecoration(
                      color: ColorConstant.green500,
                      borderRadius: BorderRadius.circular(
                        getHorizontalSize(
                          6,
                        ),
                      ),
                      border: Border.all(
                        color: ColorConstant.gray50,
                        width: getHorizontalSize(
                          1,
                        ),
                        strokeAlign: strokeAlignOutside,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 4,
              child: Padding(
                padding: getPadding(
                  left: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${widget.chat.name}",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtManropeBold16.copyWith(
                            letterSpacing: getHorizontalSize(
                              0.2,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Timeago(
                            builder: (context, value) {
                              return Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: AppStyle.txtManropeRegular14,
                              );
                            },
                            date: widget.chat.lastMessage == null
                                ? widget.chat.createdAt!
                                : widget.chat.lastMessage!.createdAt!,
                            locale: "fr_short",
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: getPadding(
                        top: 9,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.chat.lastMessage == null
                                  ? 'Nouvelle discussion'
                                  : widget.chat.lastMessage!.isDeleted == true
                                      ? "Ce message a été supprimé"
                                      : "${widget.chat.lastMessage!.isSender ? 'Vous: ' : ''}${widget.chat.lastMessage!.content!}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeMedium14Bluegray500,
                            ),
                          ),
                          FutureBuilder<DatabaseResponse>(
                              future: _getUnread,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  if (snapshot.data!.isSuccess) {
                                    if (snapshot.data!.count > 0) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                            color: AppColor.primary,
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Text(
                                          snapshot.data!.count.numeral(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      );
                                    }
                                  }
                                }
                                return const SizedBox();
                              })
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
