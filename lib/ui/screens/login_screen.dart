//import 'package:hostmi/ui/pages/main_screen.dart';
//import 'package:hostmi/ui/pages/register_screen.dart';
import 'dart:async';
import 'dart:ui';

import 'package:go_router/go_router.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/screens/ball_loading_page.dart';
import 'package:hostmi/ui/screens/login_phone_number_screen.dart';
import 'package:hostmi/ui/screens/main_screen.dart';
import 'package:hostmi/ui/screens/register_screen.dart';
import 'package:hostmi/ui/widgets/square_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/utils/app_text_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final SizedBox _spacer = const SizedBox(height: 20);

  bool _isLoading = false;

  bool _redirecting = false;

  final _formState = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  late final StreamSubscription<AuthState> _authStateSubscription;

  Role role = getRole();

  Future<void> _signIn() async {
    if (_formState.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });

        await supabase.auth.signInWithPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
        if (mounted) {
          //_emailController.clear();
          //_passwordController.clear();
        }
      } on AuthException catch (error) {
        if (error.statusCode == '400') {
          _loginErrorDialog(
            title: "Problème de connexion",
            content: "Email ou mot de passe incorrect.",
          );
        }
      } catch (error) {
        print(error);
        _loginErrorDialog(
          title: "Problème de connexion",
          content: "Vérifiez votre connexion internet et réessayer.",
        );
        SnackBar(
          content: const Text("Une erreur s'est produite. Veuillez réessayer"),
          backgroundColor: Theme.of(context).colorScheme.error,
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

  _loginErrorDialog({required String title, required String content}) {
    showErrorDialog(
      title: title,
      content: content,
      context: context,
    );
  }

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        if (role == Role.DEVELOPER) {
          context.go(keyPublishRoute);
        } else if (role == Role.TENANT) {
          context.go("/list");
        } else {
          context.go("/");
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

  @override
  Widget build(BuildContext context) {
    return _isLoading ?
    Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LoadingAnimationWidget.threeArchedCircle(
              color: AppColor.primary,
              size: getSize(50),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "Connexion en cours\nVeuillez patienter...",
              textAlign: TextAlign.center,
            ),
        ]
        ),
      ),
    )
        :
      Scaffold(
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
                    key: _formState,
                    child: Column(
                      children: [
                        _spacer,
                        SquareTextField(
                          prefixIcon: const Icon(
                            Icons.email,
                            color: AppColor.primary,
                          ),
                          placeholder: "example@email.com",
                          errorText: 'Veuillez saisir votre email',
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                        _spacer,
                        SquareTextField(
                          controller: _passwordController,
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
                              onPressed: _isLoading ? null : _signIn,
                              child: Text(
                                _isLoading
                                    ? 'Chargement...'
                                    : AppLocalizations.of(context)!.login,
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
