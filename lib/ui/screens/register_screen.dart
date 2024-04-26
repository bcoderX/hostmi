import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/firebase/analytics_client.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/core/utils/color_constant.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/alerts/info_dialog.dart';
import 'package:hostmi/ui/screens/privacy_policies/privacy_policies.dart';
import 'package:hostmi/ui/screens/terms_and_conditions/terms_and_conditions.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/ui/widgets/expandable_page_view.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/utils/app_text_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../api/constants/roles.dart';
import '../../api/supabase/supabase_client.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String initialCountry = 'BF';
  PhoneNumber phone = PhoneNumber(isoCode: 'BF');
  bool _isLoading = false;
  bool _redirecting = false;
  bool _isPasswordVisible = false;
  bool _hasAcceptedConditions = false;
  double? _tabIndex = 0;
  final SizedBox _spacer = const SizedBox(height: 3);
  final _emailFormState = GlobalKey<FormState>();
  final _phoneFormState = GlobalKey<FormState>();
  late final TextEditingController _phoneNumberPasswordController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final PageController _pageController;
  late final StreamSubscription<AuthState> _authStateSubscription;
  Role role = getRole();

  Future<void> _signUP() async {
    if (_emailFormState.currentState!.validate()) {
      if (_hasAcceptedConditions) {
        try {
          setState(() {
            _isLoading = true;
          });

          AuthResponse response = await supabase.auth.signUp(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());
          bool userExist = response.user != null &&
              response.user!.identities != null &&
              response.user!.identities!.isEmpty;
          if (!userExist) {
            analytics.logSignUp(
                signUpMethod: "Email", parameters: {"confirmed": "false"});
            context
                .push("/verify-register-otp/${_emailController.text}/verify");
          } else {
            _registerErrorDialog(
              title: "Utilisateur existant",
              content:
                  "Il semble qu'il y'ait un compte associé à cet email. Veuillez vous rendre dans la page de connexion",
            );
          }
        } on AuthException catch (error) {
          debugPrint("${error.statusCode}: ${error.message}");
          if (error.message == 'User already registered') {
            _registerErrorDialog(
              title: "Utilisateur existant",
              content:
                  "Il semble qu'il y'ait un compte associé à cet email. Veuillez vous rendre dans la page de connexion",
            );
          } else if (error.statusCode == '400') {
            _registerErrorDialog(
              title: "Problème de connexion",
              content: "Nous ne parvenous pas à créer un compte",
            );
          } else if (error.statusCode == '422') {
            _registerErrorDialog(
              title: "Mot de passe trop court",
              content: "Saisir au moins six(6) caractères.",
            );
          } else if (error.statusCode == '429') {
            _registerErrorDialog(
              title: "Impossible d'envoyer l'email",
              content: "Veuillez réessayer dans une heure",
            );
          } else if (error.statusCode == "500") {
            _registerErrorDialog(
              title: "Erreur d'envoi",
              content: "Nous n'arrivons pas à envoyer l'email",
            );
          }
        } catch (error) {
          debugPrint(error.toString());
          _registerErrorDialog(
            title: "Problème de connexion",
            content: "Vérifiez votre connexion internet et réessayer.",
          );
        } finally {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      } else {
        _registerErrorDialog(
          title: "Conditions d'utilisation",
          content:
              "Veuillez acceptez les conditions d'utilisations avant de continuer.",
        );
      }
    }
  }

  Future<void> _signUpWithPhoneAndPassword() async {
    showInfoDialog(
        title: "Confirmer le numéro",
        content:
            "Un code de de vérifcation à 6 chiffres sera envoyé par sms au ${phone.phoneNumber}. Assusrez vous qu'il s'agit bien de votre numéro.",
        ignoreTitle: "Modifier",
        actionTitle: "Oui, continuer",
        context: context,
        onClick: () async {
          try {
            setState(() {
              _isLoading = true;
            });
            FunctionResponse res = await supabase.functions.invoke(
              "auth",
              body: {
                "operation": "signup",
                "phone": phone.phoneNumber?.replaceAll("+", "").trim(),
                "password": _phoneNumberPasswordController.text,
              },
            );

            if (res.data["success"]) {
              analytics.logSignUp(
                  signUpMethod: "Phone", parameters: {"confirmed": "false"});
              context.push("/verify-register-otp/verify/${phone.phoneNumber}");
            } else if (res.data["message"] == "User already confirmed") {
              _registerErrorDialog(
                title: "Utilisateur existant",
                content:
                    "Il semble qu'il y'ait un compte associé à ce numéro de téléphone. Veuillez vous rendre dans la page de connexion",
              );
            } else {
              _registerErrorDialog(
                title: "Erreur",
                content: "Echec de la création du compte. Veuillez réessayer.",
              );
            }
          } catch (error) {
            _registerErrorDialog(
              title: "Problème de connexion",
              content: "Vérifiez votre connexion internet et réessayer.",
            );
            debugPrint(error.toString());
          } finally {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          }
        });
  }

  Future<void> _sendConfirmationEmail() async {
    showInfoDialog(
        title: "Confirmer votre email",
        content:
            "Un code de de vérifcation à 6 chiffres vous sera envoyé par email. Assusrez vous qu'il s'agit bien de votre email.",
        ignoreTitle: "Modifier",
        actionTitle: "Oui, continuer",
        context: context,
        onClick: () async {
          try {
            setState(() {
              _isLoading = true;
            });
            ResendResponse response = await supabase.auth.resend(
              email: _emailController.text,
              type: OtpType.signup,
            );
            context
                .push("/verify-register-otp/${_emailController.text}/verify");
          } on AuthException catch (error) {
            if (error.statusCode == '400') {
              _registerErrorDialog(
                title: "Problème de connexion",
                content:
                    "Numéro de téléphone incorrect. Vérifiez vous avez créé un compte avec ce numéro.",
              );
              debugPrint(error.toString());
            }
          } catch (error) {
            _registerErrorDialog(
              title: "Problème de connexion",
              content: "Vérifiez votre connexion internet et réessayer.",
            );
            debugPrint(error.toString());
          } finally {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          }
        });
  }

  _registerErrorDialog({required String title, required String content}) {
    showErrorDialog(
      title: title,
      content: content,
      context: context,
    );
  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneNumberPasswordController = TextEditingController();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _tabIndex = _pageController.page;
        });
      });
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        context.read<HostmiProvider>().setIsLoggedIn(true);
        _redirecting = true;
        if (role == Role.DEVELOPER) {
          _navigateTo("/complete-profile/initial$keyPublishRoute");
        } else if (role == Role.TENANT) {
          _navigateTo("/complete-profile/initial/list");
        } else {
          _navigateTo("/");
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  void _navigateTo(String route) {
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.grey,
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 70,
              ),
              SizedBox(
                width: getHorizontalSize(175),
                child: Image.asset(
                  "assets/images/Logo_HostMI_coreupdated.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppLocalizations.of(context)!.createAccount.toUpperCase(),
                style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        0,
                        duration: 1.ms,
                        curve: Curves.linear,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        right: 8.0,
                        bottom: 8.0,
                        top: 8.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 4.0,
                            color: _tabIndex == 0
                                ? Colors.grey[200]!
                                : AppColor.grey,
                          ),
                          top: BorderSide(
                            width: 4.0,
                            color: _tabIndex == 0
                                ? Colors.grey[200]!
                                : AppColor.grey,
                          ),
                          bottom: BorderSide(
                            width: 4.0,
                            color: _tabIndex != 0
                                ? Colors.grey[200]!
                                : AppColor.grey,
                          ),
                          right: BorderSide(
                            width: 4.0,
                            color: Colors.grey[200]!,
                          ),
                        ),
                      ),
                      child: Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _tabIndex == 0 ? null : AppColor.primary,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        1,
                        duration: 1.ms,
                        curve: Curves.linear,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        top: 8.0,
                        right: 8.0,
                        bottom: 8.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            width: 4.0,
                            color: _tabIndex == 1
                                ? Colors.grey[200]!
                                : AppColor.grey,
                          ),
                          bottom: BorderSide(
                            width: 4.0,
                            color: _tabIndex == 0
                                ? Colors.grey[200]!
                                : AppColor.grey,
                          ),
                          right: BorderSide(
                            width: 4.0,
                            color: _tabIndex == 1
                                ? Colors.grey[200]!
                                : AppColor.grey,
                          ),
                        ),
                      ),
                      child: Text(
                        "Téléphone",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _tabIndex == 1 ? null : AppColor.primary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 4.0,
                            color: Colors.grey[200]!,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ExpandablePageView(
                  controller: _pageController,
                  children: [
                    Form(
                      key: _emailFormState,
                      child: Column(
                        children: [
                          _spacer,
                          CustomTextFormField(
                            validator: (value) {
                              final bool emailValid = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value ?? "");
                              if (emailValid) {
                                return null;
                              }
                              return "Email incorrect";
                            },
                            prefix: const Icon(
                              Icons.email,
                              color: AppColor.primary,
                            ),
                            controller: _emailController,
                            hintText: "example@email.com",
                            margin: getMargin(top: 13),
                            textInputType: TextInputType.emailAddress,
                          ),
                          _spacer,
                          CustomTextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Saisir un mot de passe";
                              } else if (value.length < 6) {
                                return "Saisir minimum six (06) caractères";
                              }
                              return null;
                            },
                            prefix: const Icon(
                              Icons.lock,
                              color: AppColor.primary,
                            ),
                            controller: _passwordController,
                            isObscureText: !_isPasswordVisible,
                            hintText: AppLocalizations.of(context)!.password,
                            margin: getMargin(top: 13),
                            textInputType: TextInputType.text,
                            suffix: IconButton(
                                color: Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(_isPasswordVisible
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_outlined)),
                          ),
                          _spacer,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                  side: const BorderSide(color: Colors.red),
                                  value: _hasAcceptedConditions,
                                  semanticLabel: "J'accepte les conditions'",
                                  onChanged: (value) {
                                    setState(() {
                                      _hasAcceptedConditions = value!;
                                    });
                                  }),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Semantics(
                                  label:
                                      "J'ai lu et j'accepte les conditions d'utilisations et les politiques de confidentialté",
                                  child: RichText(
                                    text: TextSpan(
                                      text: "J'ai lu et j'accepte les ",
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300),
                                      children: [
                                        TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    TermsAndConditionsScreen(),
                                              ));
                                            },
                                          text: "conditions d'utilisations",
                                          style: const TextStyle(
                                            color: AppColor.primary,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        const TextSpan(text: " et les "),
                                        TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    PrivacyPocilcyScreen(),
                                              ));
                                            },
                                          text: "politiques de confidentialté",
                                          style: const TextStyle(
                                            color: AppColor.primary,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                        const TextSpan(text: "."),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: getPadding(top: 8.0, bottom: 8.0),
                            child: DefaultAppButton(
                              onPressed: _isLoading ? null : _signUP,
                              text: _isLoading
                                  ? 'Veuillez patienter...'
                                  : "Créer mon compte",
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Vous avez déjà un compte ?",
                                style:
                                    TextStyle(fontSize: AppTextSize.normal12),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push("/login");
                                },
                                child: const Text(
                                  "Se connecter",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _phoneFormState,
                      child: Column(
                        children: [
                          _spacer,
                          const SizedBox(
                            height: 12.0,
                          ),
                          InternationalPhoneNumberInput(
                            errorMessage: "Numéro de téléphone incorrect",
                            onInputChanged: (PhoneNumber number) {
                              print(number.phoneNumber);
                              phone = number;
                            },
                            onInputValidated: (bool value) {
                              print(value);
                            },
                            inputDecoration: InputDecoration(
                                contentPadding: getPadding(),
                                filled: true,
                                fillColor: ColorConstant.blueGray50,
                                hintText: "Numéro de téléphone",
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5.0),
                                        bottomRight: Radius.circular(5.0)))),
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.DIALOG,
                              setSelectorButtonAsPrefixIcon: true,
                              leadingPadding: 15.0,
                              // useBottomSheetSafeArea: true,
                            ),
                            ignoreBlank: false,
                            autoValidateMode:
                                AutovalidateMode.onUserInteraction,
                            selectorTextStyle:
                                const TextStyle(color: Colors.black),
                            initialValue: phone,
                            formatInput: true,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: false, decimal: false),
                          ),
                          _spacer,
                          CustomTextFormField(
                            prefix: const Icon(
                              Icons.lock,
                              color: AppColor.primary,
                            ),
                            controller: _phoneNumberPasswordController,
                            isObscureText: !_isPasswordVisible,
                            hintText: AppLocalizations.of(context)!.password,
                            margin: getMargin(top: 13),
                            textInputType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Saisir un mot de passe";
                              } else if (value.length < 6) {
                                return "Saisir minimum six (06) caractères";
                              }
                              return null;
                            },
                            suffix: IconButton(
                                color: Colors.grey,
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                icon: Icon(_isPasswordVisible
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_outlined)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                  side: const BorderSide(color: Colors.red),
                                  value: _hasAcceptedConditions,
                                  semanticLabel: "J'accepte les conditions'",
                                  onChanged: (value) {
                                    setState(() {
                                      _hasAcceptedConditions = value!;
                                    });
                                  }),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: "J'ai lu et j'accepte les ",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300),
                                    children: [
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  TermsAndConditionsScreen(),
                                            ));
                                          },
                                        text: "conditions d'utilisations",
                                        style: const TextStyle(
                                          color: AppColor.primary,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const TextSpan(text: " et les "),
                                      TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PrivacyPocilcyScreen(),
                                              ),
                                            );
                                          },
                                        text: "politiques de confidentialté",
                                        style: const TextStyle(
                                          color: AppColor.primary,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      const TextSpan(text: "."),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: getPadding(top: 8.0, bottom: 8.0),
                            child: DefaultAppButton(
                              onPressed: () {
                                if (_phoneFormState.currentState!.validate()) {
                                  if (_hasAcceptedConditions) {
                                    _signUpWithPhoneAndPassword();
                                  } else {
                                    _registerErrorDialog(
                                      title: "Conditions d'utilisation",
                                      content:
                                          "Veuillez acceptez les conditions d'utilisations avant de continuer.",
                                    );
                                  }
                                }
                              },
                              text: _isLoading
                                  ? 'Veuillez patienter...'
                                  : "Créer mon compte",
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Vous avez déjà un compte ?",
                                style:
                                    TextStyle(fontSize: AppTextSize.normal12),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push("/login");
                                },
                                child: const Text(
                                  "Se connecter",
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
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
