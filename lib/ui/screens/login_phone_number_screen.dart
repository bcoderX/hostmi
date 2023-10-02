//import 'package:hostmi/ui/pages/main_screen.dart';
//import 'package:hostmi/ui/pages/register_screen.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/core/utils/color_constant.dart';
import 'package:hostmi/ui/screens/ball_loading_page.dart';
import 'package:hostmi/ui/screens/login_screen.dart';
import 'package:hostmi/ui/screens/main_screen.dart';
import 'package:hostmi/ui/screens/verify_phone_number_screen/verify_phone_number_screen.dart';
import 'package:hostmi/ui/widgets/square_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/utils/app_text_size.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/widgets/custom_phone_number.dart';
import 'package:provider/provider.dart';

class LoginPhoneNumberPage extends StatefulWidget {
  const LoginPhoneNumberPage({Key? key}) : super(key: key);
  static const String path = "login";

  @override
  State<LoginPhoneNumberPage> createState() => _LoginPhoneNumberPageState();
}

class _LoginPhoneNumberPageState extends State<LoginPhoneNumberPage> {
  Country selectedCountry = CountryPickerUtils.getCountryByPhoneCode('226');

  TextEditingController phoneNumberController = TextEditingController();
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
                    "Se connecter",
                    style: Theme.of(context).primaryTextTheme.titleLarge,
                  ),
                  Text(
                    "Veuillez saisir votre numéro de téléphone",
                    style: TextStyle(color: ColorConstant.gray700),
                  ),
                  _spacer,
                  Form(
                    child: Column(
                      children: [
                        _spacer,
                        CustomPhoneNumber(
                            country: selectedCountry,
                            controller: phoneNumberController,
                            onTap: (Country country) {
                              setState(() {
                                selectedCountry = country;
                              });
                            }),
                        _spacer,
                        SizedBox(
                          width: double.infinity,
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppColor.primary,
                            child: MaterialButton(
                              onPressed: () {
                                debugPrint(selectedCountry.phoneCode +
                                    phoneNumberController.text);
                                //context.go("/phone-login/code/");

                              },
                              child: const Text(
                                "Se connecter",
                                style: TextStyle(
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
                            const Text(
                              "ou se connecter avec votre",
                              style: TextStyle(fontSize: AppTextSize.normal12),
                            ),
                            TextButton(
                              onPressed: () {
                                context.go("/login");
                              },
                              child: const Text("email."),
                            )
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
