import 'package:flutter/material.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/ui/screens/loading_page.dart';
import 'package:hostmi/ui/screens/message_screen/user_messages_widget.dart';
import 'package:hostmi/utils/app_color.dart';

class AgencyMessagesWidget extends StatefulWidget {
  const AgencyMessagesWidget({super.key});

  @override
  State<AgencyMessagesWidget> createState() => _AgencyMessagesWidgetState();
}

class _AgencyMessagesWidgetState extends State<AgencyMessagesWidget>
    with AutomaticKeepAliveClientMixin {
  late Future<List<AgencyModel?>> _future;

  @override
  void initState() {
    _future = getAgencyDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<AgencyModel?>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Une erreur s'est produite. Recharger la page"),
                  IconButton(
                      onPressed: () {
                        _future = getAgencyDetails().whenComplete(() {
                          setState(() {});
                        });
                      },
                      icon: const Icon(
                        Icons.replay_circle_filled_rounded,
                        size: 40,
                        color: AppColor.primary,
                      ))
                ],
              ),
            ));
          }
          if (!snapshot.hasData) {
            return const BallLoadingPage(
                loadingTitle: "Recherche de votre agence...");
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            if (snapshot.data![0] != null) {
              return UserMessagesWidget(
                isAgency: true,
                agencyId: snapshot.data![0]!.id,
              );
            } else {
              return Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        "Vérifier votre connexion internet et réessayer:"),
                    IconButton(
                      onPressed: () {
                        _future = getAgencyDetails();
                      },
                      icon: const Icon(
                        Icons.replay_circle_filled_rounded,
                        size: 40,
                        color: AppColor.primary,
                      ),
                    )
                  ],
                ),
              ));
            }
          }

          return const Center(
            child: Text("Vous n'avez pas d'agence"),
          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
