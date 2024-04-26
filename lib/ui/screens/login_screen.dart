//import 'package:hostmi/ui/pages/main_screen.dart';
//import 'package:hostmi/ui/pages/register_screen.dart';
import 'dart:async';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/firebase/analytics_client.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/rest/users/is_profile_completed.dart';
import 'package:hostmi/core/utils/color_constant.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/alerts/info_dialog.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/ui/widgets/expandable_page_view.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/utils/app_text_size.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import '../../api/constants/roles.dart';
import '../../api/hostmi_local_database/hostmi_local_database.dart';
import '../../api/supabase/supabase_client.dart';
import '../../core/utils/size_utils.dart';
import '../../routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final SizedBox _spacer = const SizedBox(height: 3);
  String initialCountry = 'BF';
  PhoneNumber phone = PhoneNumber(isoCode: 'BF');

  bool _isLoading = false;
  bool _redirecting = false;
  bool _isPasswordVisible = false;
  double? _tabIndex = 0;
  bool _hasNotPassword = false;
  bool _hasNotEmailPassword = false;

  final _emailFormState = GlobalKey<FormState>();
  final _phoneFormState = GlobalKey<FormState>();
  late final TextEditingController _phoneNumberPasswordController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final PageController _pageController;

  late final StreamSubscription<AuthState> _authStateSubscription;

  Role role = getRole();

  Future<void> _signIn() async {
    if (_emailFormState.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });

        await supabase.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        analytics
            .logLogin(loginMethod: "Email", parameters: {"confirmed": "false"});
      } on AuthException catch (error) {
        if (error.statusCode == '400') {
          _loginErrorDialog(
            title: "Problème de connexion",
            content: "Email ou mot de passe incorrect.",
          );
        }
      } catch (error) {
        debugPrint(error.toString());
        _loginErrorDialog(
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
    }
  }

  Future<void> _signInWithPhoneAndPassword() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await supabase.auth.signInWithPassword(
          phone: phone.phoneNumber?.replaceAll("+", ""),
          password: _phoneNumberPasswordController.text);
      analytics
          .logLogin(loginMethod: "Phone", parameters: {"confirmed": "false"});
    } on AuthException catch (error) {
      if (error.statusCode == '400') {
        _loginErrorDialog(
          title: "Problème de connexion",
          content: "Numéro de téléphone ou mot de passe incorrect.",
        );
        debugPrint(error.toString());
      }
    } catch (error) {
      _loginErrorDialog(
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
  }

  Future<void> _signInWithPhoneOnly() async {
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
                "operation": "login",
                "phone": phone.phoneNumber?.replaceAll("+", "").trim(),
              },
            );
            debugPrint(res.data.toString());
            if (res.data["success"]) {
              analytics.logLogin(
                  loginMethod: "Reset phone", parameters: {"confirmed": "false"});
              context.push("/verify-login-otp/verify/${phone.phoneNumber}");
            } else if (res.data["message"] == "User not registered") {
              _loginErrorDialog(
                title: "Utilisateur non trouvé",
                content:
                    "Il semble qu'il n'y ait aucun compte associé à ce numéro de téléphone. Veuillez vous rendre dans la page de création de compte",
              );
            } else {
              _loginErrorDialog(
                title: "Erreur",
                content: "Echec de l'envoi du message. Veuillez réessayer.",
              );
            }
          } catch (error) {
            _loginErrorDialog(
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

  _loginErrorDialog({required String title, required String content}) {
    showErrorDialog(
      title: title,
      content: content,
      context: context,
    );
  }

  Future<void> _signInWithEmailOnly() async {
    if (_emailFormState.currentState!.validate()) {
      showInfoDialog(
          title: "Rénitialiser votre mot de passe",
          content:
              "Un code de de vérifcation à 6 chiffres sera envoyé à ${_emailController.text}. Assusrez vous qu'il s'agit bien de votre email.",
          ignoreTitle: "Modifier",
          actionTitle: "Oui, continuer",
          context: context,
          onClick: () async {
            try {
              setState(() {
                _isLoading = true;
              });
              await supabase.auth.resetPasswordForEmail(
                _emailController.text,
              );
              analytics.logLogin(
                  loginMethod: "Reset Email", parameters: {"confirmed": "false"});
              context.push("/verify-login-otp/${_emailController.text}/verify");
            } on AuthException catch (error) {
              if (error.statusCode == '400') {
                _loginErrorDialog(
                  title: "Problème de connexion",
                  content:
                      "Numéro de téléphone incorrect. Vérifiez vous avez créé un compte avec ce numéro.",
                );
                debugPrint(error.toString());
              }
            } catch (error) {
              _loginErrorDialog(
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
        _checkProfileStatus();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
    _pageController.dispose();
    super.dispose();
  }

  _checkProfileStatus() async {
    DatabaseResponse profileStatus;
    if (supabase.auth.currentUser != null) {
      profileStatus = await getProfileStatus(supabase.auth.currentUser!.id);

      if (profileStatus.isSuccess) {
        if (profileStatus.isTrue) {
          if (role == Role.DEVELOPER) {
            _navigateTo(keyPublishRoute);
          } else if (role == Role.TENANT) {
            _navigateTo("/list");
          } else {
            _pushRoute("/choose-role/login");
          }
        } else {
          if (role == Role.DEVELOPER) {
            _navigateTo("/complete-profile/initial$keyPublishRoute");
          } else if (role == Role.TENANT) {
            _navigateTo("/complete-profile/initial/list");
          } else {
            _pushRoute("/choose-role/login");
          }
        }
      } else {
        _loginErrorDialog(
          title: "Erreur",
          content:
              "Une erreur inconnue s'est produite. Vérifier votre connexion:",
        );
      }
    }
  }

  void _navigateTo(String route) {
    context.go(route);
  }

  void _pushRoute(String route) {
    context.push(route);
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
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.login.toUpperCase(),
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
                          _hasNotEmailPassword == false
                              ? CustomTextFormField(
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
                                  hintText:
                                      AppLocalizations.of(context)!.password,
                                  margin: getMargin(top: 13),
                                  textInputType: TextInputType.text,
                                  suffix: IconButton(
                                      color: Colors.grey,
                                      onPressed: () {
                                        setState(() {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                      icon: Icon(_isPasswordVisible
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_outlined)),
                                )
                              : const SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                  value: _hasNotEmailPassword,
                                  semanticLabel: "Je n'ai pas de mot de passe",
                                  onChanged: (value) {
                                    setState(() {
                                      _hasNotEmailPassword = value!;
                                    });
                                  }),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text("J'ai oublié mon mot de passe"),
                            ],
                          ),
                          _spacer,
                          Padding(
                            padding: getPadding(top: 8.0, bottom: 8.0),
                            child: DefaultAppButton(
                              onPressed: _isLoading
                                  ? null
                                  : _hasNotEmailPassword
                                      ? _signInWithEmailOnly
                                      : _signIn,
                              text: _isLoading
                                  ? 'Veuillez patienter...'
                                  : _hasNotEmailPassword
                                      ? "Rénitialiser le mot de passe"
                                      : "Se connecter",
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Vous n'avez pas de compte ?",
                                style:
                                    TextStyle(fontSize: AppTextSize.normal12),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push("/register");
                                },
                                child: const Text(
                                  "Créer",
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              context.go("/map");
                            },
                            child: Text(
                              "Accueil",
                              style: TextStyle(color: Colors.grey[800]),
                            ),
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
                          _hasNotPassword == false
                              ? CustomTextFormField(
                                  prefix: const Icon(
                                    Icons.lock,
                                    color: AppColor.primary,
                                  ),
                                  controller: _phoneNumberPasswordController,
                                  isObscureText: !_isPasswordVisible,
                                  hintText:
                                      AppLocalizations.of(context)!.password,
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
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        });
                                      },
                                      icon: Icon(_isPasswordVisible
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_outlined)),
                                )
                              : const SizedBox(),
                          // _isSent ?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Checkbox(
                                  value: _hasNotPassword,
                                  semanticLabel: "Je n'ai pas de mot de passe",
                                  onChanged: (value) {
                                    setState(() {
                                      _hasNotPassword = value!;
                                    });
                                  }),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text("J'ai oublié mon mot de passe"),
                            ],
                          ),
                          Padding(
                            padding: getPadding(top: 8.0, bottom: 8.0),
                            child: DefaultAppButton(
                              onPressed: () {
                                if (_phoneFormState.currentState!.validate()) {
                                  if (_hasNotPassword) {
                                    _signInWithPhoneOnly();
                                  } else {
                                    _signInWithPhoneAndPassword();
                                  }
                                }
                              },
                              text: _isLoading
                                  ? 'Veuillez patienter...'
                                  : _hasNotPassword
                                      ? "Rénitialiser le mot de passe"
                                      : "Se connecter",
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Vous n'avez pas de compte ?",
                                style:
                                    TextStyle(fontSize: AppTextSize.normal12),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.push("/register");
                                },
                                child: const Text(
                                  "Créer",
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              context.go("/map");
                            },
                            child: Text(
                              "Accueil",
                              style: TextStyle(color: Colors.grey[800]),
                            ),
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
