import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/models/chat_model.dart';
import 'package:hostmi/api/supabase/rest/messages/select_agency_chats.dart';
import 'package:hostmi/api/supabase/rest/messages/select_user_chats.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/api/utils/check_internet_status.dart';
import 'package:hostmi/core/utils/color_constant.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/ui/screens/loading_page.dart';
import 'package:hostmi/ui/screens/message_screen/message_details_screen.dart';
import 'package:hostmi/ui/screens/message_screen/widgets/message_item_widget.dart';

class UserMessagesWidget extends StatefulWidget {
  const UserMessagesWidget({
    super.key,
    this.userId,
    this.agencyId,
    required this.isAgency,
  });
  final String? userId;
  final String? agencyId;
  final bool isAgency;

  @override
  State<UserMessagesWidget> createState() => _UserMessagesWidgetState();
}

class _UserMessagesWidgetState extends State<UserMessagesWidget>
    with AutomaticKeepAliveClientMixin {
  List<ChatModel> chats = [];
  Future<DatabaseResponse>? _chatsFuture;
  bool _isFirst = true;
  bool _hasError = false;
  @override
  void initState() {
    startListening();
    _chatsFuture = widget.isAgency
        ? selectAgencyChats(widget.agencyId!)
        : selectUserChats(widget.userId!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var screenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder<DatabaseResponse>(
        future: _chatsFuture,
        // Just like in apollo refetch() could be used to manually trigger a refetch
        // while fetchMore() can be used for pagination purpose
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: screenHeight * 0.7,
              child: const BallLoadingPage(
                loadingTitle: "Chargement des discussions...",
              ),
            );
          }

          if (snapshot.hasData) {
            final response = snapshot.data!;
            if (response.isSuccess) {
              _isFirst = false;
              if (response.list!.isEmpty) {
                return const Center(child: Text('Aucune conversation'));
              } else {
                chats = response.list!.map(
                  (e) {
                    return ChatModel.fromMap(
                        e, widget.isAgency, supabase.auth.currentUser!.id);
                  },
                ).toList();
                if (chats[0].lastMessage != null) {
                  chats.sort(
                    (a, b) {
                      if (a.lastMessage == null && b.lastMessage != null) {
                        return a.createdAt!
                            .compareTo(b.lastMessage!.createdAt!);
                      }
                      if (a.lastMessage != null && b.lastMessage == null) {
                        return a.lastMessage!.createdAt!
                            .compareTo(b.createdAt!);
                      }
                      if (a.lastMessage == null && b.lastMessage == null) {
                        return 0;
                      }
                      return a.lastMessage!.createdAt!
                          .compareTo(b.lastMessage!.createdAt!);
                    },
                  );
                }

                return Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _hasError
                            ? Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.red,
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        "Une erreur s'est produite",
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1)),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        startListening();
                                        // _chatsFuture = widget.isAgency
                                        //     ? selectAgencyChats(
                                        //             widget.agencyId!)
                                        //         .whenComplete(() {
                                        //         setState(() {});
                                        //       })
                                        //     : selectUserChats(widget.userId!)
                                        //         .whenComplete(() {
                                        //         setState(() {});
                                        //       });
                                      },
                                      child: const Text("Recharger"),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        Container(
                            width: double.maxFinite,
                            padding: getPadding(
                                left: 24, top: 42, right: 24, bottom: 42),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ListView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    reverse: true,
                                    children: chats.map((e) {
                                      return Padding(
                                        padding:
                                            getPadding(top: 17.0, bottom: 17.0),
                                        child: MessageItemWidget(
                                          receiverId: widget.isAgency
                                              ? widget.agencyId!
                                              : widget.userId!,
                                          onTaptf: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        MessagesDetailsScreen(
                                                  userId: '${e.userId}',
                                                  agencyId: '${e.agencyId}',
                                                  opener: widget.isAgency
                                                      ? 'agency'
                                                      : 'user',
                                                  onMessageSent: () async {
                                                    bool isConnected =
                                                        await checkInternetStatus();
                                                    if (isConnected) {
                                                      _chatsFuture = widget
                                                              .isAgency
                                                          ? selectAgencyChats(
                                                                  widget
                                                                      .agencyId!)
                                                              .whenComplete(() {
                                                              setState(() {});
                                                            })
                                                          : selectUserChats(
                                                                  widget
                                                                      .userId!)
                                                              .whenComplete(() {
                                                              setState(() {});
                                                            });
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Vérifiez votre connexion...",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                          chat: e,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  Padding(
                                    padding: getPadding(top: 14, bottom: 5),
                                    child: Divider(
                                        height: getVerticalSize(1),
                                        thickness: getVerticalSize(1),
                                        color: ColorConstant.blueGray50),
                                  ),
                                ])),
                      ],
                    ),
                  ),
                );
              }
            }
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Aucun message"),
              ElevatedButton(
                  onPressed: () {
                    startListening();
                    _chatsFuture = widget.isAgency
                        ? selectAgencyChats(widget.agencyId!).whenComplete(() {
                            setState(() {});
                          })
                        : selectUserChats(widget.userId!).whenComplete(() {
                            setState(() {});
                          });
                  },
                  child: const Text("Recharger"))
            ],
          );
        });
  }

  void startListening() {
    if (_hasError || _isFirst) {
      try {
        supabase
            .from("messages")
            .stream(
              primaryKey: ["id", "is_deleted", "is_read", "is_received"],
            )
            .eq(
              "receiver_id",
              widget.isAgency ? widget.agencyId : widget.userId,
            )
            .order("created_at")
            .limit(1)
            .listen((event) {
              if (!_isFirst) {
                _chatsFuture = widget.isAgency
                    ? selectAgencyChats(widget.agencyId!).whenComplete(() {
                        setState(() {
                          _hasError = false;
                        });
                      })
                    : selectUserChats(widget.userId!).whenComplete(() {
                        setState(() {
                          _hasError = false;
                        });
                      });
              }
              debugPrint(event.length.toString());
            }, onError: (error) {
              setState(() {
                _hasError = true;
              });
            });
      } catch (e) {
        debugPrint(e.toString());
        setState(() {
          _hasError = true;
        });
      }
    }
  }

  // Future<ChatModel> _getChat(String chatId) async {
  //   DatabaseResponse selectResponse = widget.isAgency
  //       ? await selectAgencyChatId(chatId)
  //       : await selectUserChatId(chatId);
  //   if (selectResponse.isSuccess) {
  //     if (selectResponse.list!.isNotEmpty) {
  //       final c = selectResponse.list![0];
  //       return ChatModel.fromMap(
  //           c, widget.isAgency, supabase.auth.currentUser!.id);
  //     }
  //   }
  //   return ChatModel();
  // }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
