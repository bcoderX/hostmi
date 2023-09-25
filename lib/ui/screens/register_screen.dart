//import 'package:hostmi/ui/pages/main_screen.dart';
//import 'package:hostmi/ui/pages/register_screen.dart';
import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/screens/ball_loading_page.dart';
import 'package:hostmi/ui/screens/login_phone_number_screen.dart';
import 'package:hostmi/ui/screens/main_screen.dart';
import 'package:hostmi/ui/widgets/square_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/utils/app_text_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../api/constants/roles.dart';
import '../../api/supabase/supabase_client.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static const String path = "login";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  bool _redirecting = false;
  final SizedBox _spacer = const SizedBox(height: 20);
  final _formState = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;
  Role role = getRole();

  Future<void> _signUP() async {
    if (_formState.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });

        await supabase.auth.signUp(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
        if (mounted) {
          //_emailController.clear();
          //_passwordController.clear();
        }
      } on AuthException catch (error) {
        print(error);
        SnackBar(
          content: Text(error.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        );
      } catch (error) {
        print(error);
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

  @override
  void initState() {
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        if (role == Role.DEVELOPER) {
          context.go("/publisher");
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
    return Scaffold(
      backgroundColor: AppColor.white,
      body: _redirecting
          ? const BallLoadingPage()
          : Scrollbar(
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                errorText: 'Veuiller saisir votre email',
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                              ),
                              _spacer,
                              SquareTextField(
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  color: AppColor.primary,
                                ),
                                placeholder:
                                    AppLocalizations.of(context)!.password,
                                errorText: 'veuillez saisir un mot de passe',
                                keyboardType: TextInputType.text,
                                isPassword: true,
                                controller: _passwordController,
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
                                    onPressed: _isLoading ? null : _signUP,
                                    child: Text(
                                      _isLoading
                                          ? 'Chargement...'
                                          : "${AppLocalizations.of(context)!.createAccount}.",
                                      style: const TextStyle(
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
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    const LoginPhoneNumberPage()));
                                      },
                                      child: Text(
                                          "${AppLocalizations.of(context)!.phoneNumber.toLowerCase()}."))
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.haveAccount,
                                    style: const TextStyle(
                                        fontSize: AppTextSize.normal12),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.go(keyLoginRoute);
                                    },
                                    child: Text(
                                      "${AppLocalizations.of(context)!.login}.",
                                    ),
                                  ),
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
