import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/screens/agency_screen/agency_manager_screen.dart';
import 'package:hostmi/ui/screens/ball_loading_page.dart';
import 'package:hostmi/ui/screens/create_agency_screen/no_agency.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:go_router/go_router.dart';

class PublisherPage extends StatefulWidget {
  const PublisherPage({Key? key}) : super(key: key);

  @override
  State<PublisherPage> createState() => _PublisherPageState();
}

class _PublisherPageState extends State<PublisherPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColor.grey,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.grey,
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

    return FutureBuilder<AgencyModel?>(
        future: getAgencyDetails(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const BallLoadingPage();
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return AgencyManagerScreen(
                agency: snapshot.data!,
              );
            }
          }
          return const NoAgency();
        });
  }
}
