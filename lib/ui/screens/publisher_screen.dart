import 'package:flutter/material.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/utils/check_connection_and_do.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/screens/agency_screen/agency_manager_screen.dart';
import 'package:hostmi/ui/screens/create_agency_screen/no_agency.dart';
import 'package:hostmi/ui/screens/loading_page.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:provider/provider.dart';

class PublisherPage extends StatefulWidget {
  const PublisherPage({Key? key}) : super(key: key);

  @override
  State<PublisherPage> createState() => _PublisherPageState();
}

class _PublisherPageState extends State<PublisherPage>
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
              const Text("Connectez vous à votre compte"),
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
                    ),
                  ),
                ],
              ),
            ));
          }
          if (!snapshot.hasData) {
            return const BallLoadingPage(
              loadingTitle: "Recherche de votre agence...",
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return NoAgency(
              onNotFound: () {
                checkConnectionAndDo(() {
                  _future = getAgencyDetails();
                });
              },
            );
          } else if (snapshot.hasData &&
              snapshot.data!.isNotEmpty &&
              snapshot.data![0] == null) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(25.0),
                    child:
                        Text("Vérifier votre connexion internet et réessayer:"),
                  ),
                  IconButton(
                      onPressed: () {
                        checkConnectionAndDo(() {
                          _future = getAgencyDetails();
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

          return AgencyManagerScreen(
            agency: snapshot.data![0]!,
          );
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
