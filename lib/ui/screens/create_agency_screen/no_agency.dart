import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoAgency extends StatelessWidget {
  const NoAgency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Pour publier votre propriété, vous devez créer une agence.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 30.0)),
              onPressed: () {
                context.go(keyCreateAgencyBasicDetailsFullRoute);
              },
              child: Text(AppLocalizations.of(context)!.createNow)),
        ],
      ),
    );
  }
}
