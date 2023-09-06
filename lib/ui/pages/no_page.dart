import 'package:flutter/material.dart';
import 'package:hostmi/ui/pages/create_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class NoPage extends StatelessWidget {
  const NoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text(
            AppLocalizations.of(context)!.mustCreatePage,
            textAlign: TextAlign.center,
            style:const TextStyle(
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return const CreatePage();
                }));
              },
              child:  Text(AppLocalizations.of(context)!.createNow)),
        ],
      ),
    );
  }
}
