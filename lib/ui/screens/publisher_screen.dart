import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/screens/agency_screen/agency_manager_screen.dart';
import 'package:hostmi/ui/screens/ball_loading_page.dart';
import 'package:hostmi/ui/screens/create_agency_screen/no_agency.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/utils/app_color.dart';

class PublisherPage extends StatefulWidget {
  const PublisherPage({Key? key}) : super(key: key);

  @override
  State<PublisherPage> createState() => _PublisherPageState();
}

class _PublisherPageState extends State<PublisherPage> {
  late Future<List<AgencyModel?>> _future;

  @override
  void initState() {
    _future = getAgencyDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.grey[200],
        statusBarIconBrightness: Brightness.dark,
        // systemNavigationBarColor: Colors.grey,
      ),
    );

    if (supabase.auth.currentUser == null) {
      return Center(
        child: InkWell(
          onTap: () {
            context.go(keyLoginRoute);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Vous devez vous connecter pour continuer"),
              TextButton(
                child: const Text("Cliquer ici pour se connecter"),
                onPressed: () {
                  context.go(keyLoginRoute);
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
                        _future = getAgencyDetails();
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
            return const BallLoadingPage();
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            if (snapshot.data![0] != null) {
              return AgencyManagerScreen(
                agency: snapshot.data![0]!,
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
                        ))
                  ],
                ),
              ));
            }
          }

          return const NoAgency();
        });
  }
}
