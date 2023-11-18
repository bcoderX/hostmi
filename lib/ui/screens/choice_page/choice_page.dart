import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/widgets/rounded_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/utils/app_text_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../api/constants/roles.dart';

class ChoicePage extends StatefulWidget {
  const ChoicePage({Key? key}) : super(key: key);

  @override
  State<ChoicePage> createState() => _ChoicePageState();
}

class _ChoicePageState extends State<ChoicePage> {
  final SizedBox _spacer = const SizedBox(height: 20);
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        // systemNavigationBarColor: Colors.grey,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/9.png",
                fit: BoxFit.fitWidth,
              ),
              Text(
                "${"${AppLocalizations.of(context)!.welcome} ${AppLocalizations.of(context)!.to}"} HostMI",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: AppColor.primary,
                    fontSize: getSize(30),
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        _spacer,
                        Text(AppLocalizations.of(context)!.whyDoYouUseHostmi),
                        _spacer,
                        SizedBox(
                            width: double.infinity,
                            child: RoundedButton(
                              buttonColor: AppColor.primary,
                              fontSize: AppTextSize.heading16,
                              text: "Je suis locataire",
                              textColor: AppColor.white,
                              onTap: () {
                                setRole(Role.TENANT);
                                context.go("/map");
                              },
                            )),
                        _spacer,
                        SizedBox(
                          width: double.infinity,
                          child: RoundedButton(
                            buttonColor: AppColor.grey,
                            fontSize: AppTextSize.heading16,
                            text: "Je suis promoteur immobilier",
                            textColor: AppColor.primary,
                            onTap: () {
                              setRole(Role.DEVELOPER);
                              context.go("/login");
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
