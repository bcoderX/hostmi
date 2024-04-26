import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/models/message_model.dart';
import 'package:hostmi/api/supabase/rest/messages/delete_message.dart';
import 'package:hostmi/api/supabase/rest/messages/update_read_date.dart';
import 'package:hostmi/core/utils/color_constant.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:timeago_flutter/timeago_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({super.key, required this.message});
  final MessageModel message;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  Radius radius = const Radius.circular(10.0);
  EdgeInsets edgeInsets = const EdgeInsets.symmetric(horizontal: 20);
  final SizedBox _spacer = const SizedBox(height: 20);
  bool showControls = false;
  bool isDeleting = false;
  String houseId = "";
  bool isDeleted = false;
  List<String> normalText = [];
  @override
  void initState() {
    if (!widget.message.isSender && !widget.message.isRead!) {
      updateReadMessage(widget.message.id!);
    }
    String link =
        RegExp(r"[(https\:\/\/hostmi\.)|(hostmi\.)]+vercel\.app\/property\-details\/+[a-zA-Z0-9]{1,8}\-+[a-zA-Z0-9]{1,4}\-+[a-zA-Z0-9]{1,4}\-+[a-zA-Z0-9]{1,4}\-+[a-zA-Z0-9]{1,12}")
                .stringMatch(widget.message.content!) ??
            "";
    if (link.isNotEmpty) {
      final arr = link.split("/");

      houseId = arr.last;
      debugPrint(houseId);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.message.isDeleted == true || isDeleted
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: (widget.message.isSender)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                width: getHorizontalSize(229),
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: (widget.message.isSender)
                      ? ColorConstant.blueGray50
                      : AppColor.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: radius,
                    topRight: radius,
                    bottomRight:
                        (widget.message.isSender) ? radius : Radius.zero,
                    bottomLeft:
                        (widget.message.isSender) ? radius : Radius.zero,
                  ),
                ),
                child: Text(
                  "Message supprimé",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: widget.message.isSender
                        ? Colors.grey[700]
                        : Colors.white,
                  ),
                ),
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: (widget.message.isSender)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              _spacer,
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    showControls = true;
                  });
                },
                onTap: () {
                  setState(() {
                    showControls = false;
                  });
                },
                child: Container(
                  width: getHorizontalSize(229),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: (widget.message.isSender)
                        ? ColorConstant.blueGray50
                        : AppColor.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: radius,
                      topRight: radius,
                      bottomRight:
                          (widget.message.isSender) ? radius : Radius.zero,
                      bottomLeft:
                          (widget.message.isSender) ? radius : Radius.zero,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Linkify(
                        options: const LinkifyOptions(),
                        onOpen: (link) async {
                          if (houseId.isNotEmpty) {
                            // Navigator.of(context).pop();
                            context.push("/property-details/$houseId");
                          } else {
                            final canOpenUrl =
                                await canLaunchUrl(Uri.parse(link.url));
                            if (canOpenUrl) {
                              await launchUrl(Uri.parse(link.url));
                            }
                          }
                        },
                        text: widget.message.content!,
                        style: TextStyle(
                            fontSize: 16,
                            color: widget.message.isSender
                                ? Colors.grey[700]
                                : Colors.white),
                        linkStyle: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (houseId.isNotEmpty)
                        Padding(
                          padding: getPadding(top: 8.0, bottom: 8.0),
                          child: DefaultAppButton(
                            color: widget.message.isSender
                                ? AppColor.primary
                                : ColorConstant.blueGray50,
                            textColor: widget.message.isSender
                                ? ColorConstant.blueGray50
                                : AppColor.primary,
                            onPressed: () {
                              context.push("/property-details/$houseId");
                            },
                            text: "Afficher la maison",
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: (widget.message.isSender)
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  Timeago(
                    builder: (context, value) {
                      return Text(
                        value,
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                    date: widget.message.createdAt!,
                    locale: "fr",
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  (widget.message.isSender)
                      ? widget.message.isRead == true
                          ? const Stack(
                              children: [
                                Icon(
                                  Icons.check,
                                  size: 13,
                                  color: Colors.green,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 4.0),
                                  child: Icon(
                                    Icons.check,
                                    size: 13,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            )
                          : widget.message.isReceived == true
                              ? const Stack(
                                  children: [
                                    Icon(
                                      Icons.check,
                                      size: 13,
                                      color: AppColor.iconBorderGrey,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4.0),
                                      child: Icon(
                                        Icons.check,
                                        size: 13,
                                        color: AppColor.iconBorderGrey,
                                      ),
                                    ),
                                  ],
                                )
                              : const Icon(
                                  Icons.check,
                                  size: 13,
                                  color: AppColor.iconBorderGrey,
                                )
                      : const SizedBox()
                ],
              ),
              showControls
                  ? Row(
                      mainAxisAlignment: (widget.message.isSender)
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        isDeleting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator())
                            : Card(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                                  text:
                                                      widget.message.content!))
                                              .then((value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    content:
                                                        Text("Message copié")));
                                          });
                                          setState(() {
                                            showControls = false;
                                          });
                                        },
                                        icon: const Icon(Icons.copy)),
                                    Container(
                                      height: 15,
                                      width: widget.message.isSender ? 1 : 0,
                                      color: AppColor.iconBorderGrey,
                                    ),
                                    widget.message.isSender
                                        ? IconButton(
                                            onPressed: () async {
                                              setState(() {
                                                isDeleting = true;
                                              });
                                              DatabaseResponse response =
                                                  await deleteMessage(
                                                      widget.message.id!);
                                              setState(() {
                                                isDeleting = false;
                                                if (response.isSuccess) {
                                                  isDeleted = true;
                                                } else {
                                                  showErrorDialog(
                                                      title:
                                                          "Erreur de suppression",
                                                      content:
                                                          "Nous n'avons pas réussi à supprimer le message",
                                                      context: context);
                                                }
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                            ))
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    )
                  : const SizedBox(),
            ],
          );
  }
}
