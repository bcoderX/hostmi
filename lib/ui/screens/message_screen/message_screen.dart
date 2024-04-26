import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/screens/message_screen/agency_messages_widget.dart';
import 'package:hostmi/ui/screens/message_screen/user_messages_widget.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (!context.watch<HostmiProvider>().isLoggedIn) {
      return Center(
        child: InkWell(
          onTap: () {
            context.push(keyLoginRoute);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Connectez vous à votre compte",
                textAlign: TextAlign.center,
              ),
              TextButton(
                child: const Text("Cliquer ici pour se connecter"),
                onPressed: () {
                  context.push(keyLoginRoute);
                },
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        animationDuration: 500.ms,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColor.grey,
            title: const Text(
              "Messages",
              style: TextStyle(
                color: AppColor.primary,
              ),
            ),
            elevation: 0.0,
            bottom: TabBar(
              tabs: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Agence ${context.watch<HostmiProvider>().unreadUserCount > 0 ? "(${context.watch<HostmiProvider>().unreadUserCount.numeral()})" : ""}",
                      style: const TextStyle(
                        color: AppColor.primary,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Locataires${context.watch<HostmiProvider>().unreadAgencyCount > 0 ? "(${context.watch<HostmiProvider>().unreadAgencyCount.numeral()})" : ""}",
                      style: const TextStyle(
                        color: AppColor.primary,
                      )),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              UserMessagesWidget(
                isAgency: false,
                userId: supabase.auth.currentUser!.id,
              ),
              const AgencyMessagesWidget()
            ],
          ),
        ),
      ),
    );
  }

  onTapArrowleft2(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
