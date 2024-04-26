import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/utils/check_connection_and_do.dart';
import 'package:hostmi/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/widgets/custom_button.dart';

class NoAgency extends StatefulWidget {
  const NoAgency({Key? key, this.onNotFound}) : super(key: key);
  final void Function()? onNotFound;

  @override
  State<NoAgency> createState() => _NoAgencyState();
}

class _NoAgencyState extends State<NoAgency> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Publier des maisons",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              "Vous êtes nouveau et prêt à trouver des locataires parmi nos millions d'utilisateurs? Cliquer sur le bouton orange.",
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(
              height: 20.0,
            ),
            DefaultAppButton(
              text: isClicked
                  ? "Chargement en cours..."
                  : "Commencez à publier des maisons",
              onPressed: () {
                setState(() {
                  isClicked = true;
                });
                checkConnectionAndDo(() async {
                  List<AgencyModel?> ag = await getAgencyDetails();
                  if (ag.isEmpty) {
                    setState(() {
                      isClicked = false;
                    });
                    context.push(
                        "$keyCreateAgencyRoute/$keyCreateAgencyBasicDetailsRoute");
                  } else if (ag[0] == null) {
                    setState(() {
                      isClicked = false;
                    });
                    Fluttertoast.showToast(
                      msg: "Problème de connexion.\nRéessayer...",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    setState(() {
                      isClicked = false;
                    });
                    Fluttertoast.showToast(
                      msg:
                          "Vous avez déjà créer une agence\nChargement en cours...",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    widget.onNotFound?.call();
                  }
                });
                Timer(500.ms, () {
                  setState(() {
                    isClicked = false;
                  });
                });
              },
            ),
            // CustomButton(
            //   onTap: () {
            //     context.push(
            //         "$keyCreateAgencyRoute/$keyCreateAgencyBasicDetailsRoute");
            //   },
            //   text: "Commencez à publier\ndes maisons",
            //   shape: ButtonShape.RoundedBorder10,
            //   variant: ButtonVariant.FillBluegray50,
            //   fontStyle: ButtonFontStyle.ManropeSemiBold16Gray900,
            // ),
            const SizedBox(
              height: 20.0,
            ),
            // const Text(
            //   "Si vous avez déjà une agence\nCliquer sur le bouton ci-dessous pour actualiser.",
            //   style: TextStyle(
            //     fontSize: 18,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            CustomButton(
              onTap: () {
                widget.onNotFound?.call();
              },
              text: "ou Actualiser\n(Si vous avez déjà créer une agence)",
              shape: ButtonShape.RoundedBorder10,
              variant: ButtonVariant.FillBluegray50,
              fontStyle: ButtonFontStyle.ManropeSemiBold16Gray900,
            ),
          ],
        ),
      ),
    );
  }
}
