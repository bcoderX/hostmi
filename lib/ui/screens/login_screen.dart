//import 'package:hostmi/ui/pages/main_screen.dart';
//import 'package:hostmi/ui/pages/register_screen.dart';
import 'dart:ui';

import 'package:go_router/go_router.dart';
import 'package:hostmi/ui/screens/ball_loading_page.dart';
import 'package:hostmi/ui/screens/login_phone_number_screen.dart';
import 'package:hostmi/ui/screens/main_screen.dart';
import 'package:hostmi/ui/screens/register_screen.dart';
import 'package:hostmi/ui/widgets/square_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/utils/app_text_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String path = "login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SizedBox _spacer = const SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                "assets/images/9.jpg",
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  Text(
                    AppLocalizations.of(context)!.login,
                    style: Theme.of(context).primaryTextTheme.titleLarge,
                  ),
                  Form(
                    child: Column(
                      children: [
                        _spacer,
                        const SquareTextField(
                          prefixIcon: Icon(
                            Icons.email,
                            color: AppColor.primary,
                          ),
                          placeholder: "example@email.com",
                          errorText: 'Please enter your email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _spacer,
                        SquareTextField(
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: AppColor.primary,
                          ),
                          placeholder: AppLocalizations.of(context)!.password,
                          errorText: 'veuillez saisir un mot de passe',
                          keyboardType: TextInputType.text,
                          isPassword: true,
                        ),
                        _spacer,
                        SizedBox(
                          width: double.infinity,
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppColor.primary,
                            child: MaterialButton(
                              onPressed: () {
                                context.go("/map");
                              },
                              child: Text(
                                AppLocalizations.of(context)!.login,
                                style: const TextStyle(
                                  fontSize: AppTextSize.heading18,
                                  color: AppColor.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        _spacer,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.orUse,
                              style: const TextStyle(
                                  fontSize: AppTextSize.normal12),
                            ),
                            TextButton(
                                onPressed: () {
                                  context.go("/phone-login");
                                },
                                child: Text(
                                    "${AppLocalizations.of(context)!.phoneNumber.toLowerCase()}."))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.doNotHaveAccount,
                              style: const TextStyle(
                                fontSize: AppTextSize.normal12,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go("/register");
                              },
                              child: Text(
                                  "${AppLocalizations.of(context)!.createAccount}."),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
