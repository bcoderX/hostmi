//import 'package:hostmi/ui/pages/main_page.dart';
//import 'package:hostmi/ui/pages/register_page.dart';
import 'package:hostmi/ui/pages/ball_loading_page.dart';
import 'package:hostmi/ui/pages/login_page.dart';
import 'package:hostmi/ui/pages/login_phone_number_page.dart';
import 'package:hostmi/ui/pages/main_page.dart';
import 'package:hostmi/ui/widgets/square_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/utils/app_text_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const String path = "login";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                "assets/images/6.jpg",
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  Text(
                    AppLocalizations.of(context)!.createAccount,
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return const MainPage(pageIndex: 3,);
                                    },
                                  ),
                                );
                              },
                              child:  Text(
                                AppLocalizations.of(context)!.create,
                                style: const TextStyle(
                                    fontSize: AppTextSize.heading18,
                                    color: AppColor.white),
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
                              style: const TextStyle(fontSize: AppTextSize.normal12),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (BuildContext context) => const LoginPhoneNumberPage())
                                  );
                                },
                                child:  Text("${AppLocalizations.of(context)!.phoneNumber.toLowerCase()}."))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                             Text(
                              AppLocalizations.of(context)!.haveAccount,
                              style: const TextStyle(fontSize: AppTextSize.normal12),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return const LoginPage();
                                      },
                                    ),
                                  );
                                },
                                child:  Text("${AppLocalizations.of(context)!.login}."))
                          ],
                        )
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
