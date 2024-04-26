import 'dart:async';

import 'package:go_router/go_router.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/rest/users/is_profile_completed.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/utils/color_constant.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:supabase/supabase.dart';

import '../../api/constants/roles.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);
  static const String path = "login";

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final StreamSubscription<AuthState> _authStateSubscription;
  bool _isPasswordVisible = false;
  bool _redirecting = false;
  Role role = getRole();
  final GlobalKey<FormState> _formState = GlobalKey();
  bool _isLoading = false;
  final SizedBox _spacer = const SizedBox(height: 20);
  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      if (session != null) {
        context.read<HostmiProvider>().setIsLoggedIn(true);
        _redirecting = true;
        if (event == AuthChangeEvent.userUpdated) {
          _checkProfileStatus();
        }
      }
    });
    super.initState();
  }

  Future<void> _resetPassword() async {
    if (_formState.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true;
        });

        UserResponse response = await supabase.auth.updateUser(
            UserAttributes(password: _passwordController.text.trim()));
        debugPrint(response.user?.email.toString());
        _checkProfileStatus();
      } on AuthException catch (error) {
        if (error.statusCode == '400') {
          _loginErrorDialog(
            title: "Erreur inconnue",
            content: "Une erreur inconnue s'est produite.",
          );
        }
        if (error.statusCode == '422') {
          _loginErrorDialog(
            title: "Erreur de mot de passe",
            content:
                "Votre nouveau mot de passe ressemble trop à votre ancien mot de passe. Saisissez un autre.",
          );
        }
      } catch (error) {
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

  _loginErrorDialog({required String title, required String content}) {
    showErrorDialog(
      title: title,
      content: content,
      context: context,
    );
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
            _navigateTo("/");
          }
        } else {
          if (role == Role.DEVELOPER) {
            _navigateTo("/complete-profile/initial$keyPublishRoute");
          } else if (role == Role.TENANT) {
            _navigateTo("/complete-profile/initial/list");
          } else {
            _navigateTo("/");
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

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: screen.height * 0.3,
              ),
              Form(
                key: _formState,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(children: [
                    Text(
                      "Nouveau mot de passe",
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                    ),
                    Text(
                      "Entrer un nouveau mot de passe dans les champs suivants",
                      style: TextStyle(color: ColorConstant.gray700),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                          hintText: "Nouveau mot de passe",
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
                        CustomTextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Confirmer mot de passe";
                            } else if (value.length < 6) {
                              return "Saisir minimum six (06) caractères";
                            } else if (_passwordController.text !=
                                _confirmPasswordController.text) {
                              return "Les mots de passe ne correspondent pas";
                            }
                            return null;
                          },
                          prefix: const Icon(
                            Icons.lock,
                            color: AppColor.primary,
                          ),
                          controller: _confirmPasswordController,
                          isObscureText: !_isPasswordVisible,
                          hintText: "Confirmer mot de passe",
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
                        Padding(
                          padding: getPadding(top: 8.0, bottom: 8.0),
                          child: DefaultAppButton(
                            onPressed: () {
                              if (_formState.currentState!.validate()) {
                                _resetPassword();
                              }
                            },
                            text: _isLoading
                                ? 'Veuillez patienter...'
                                : "Rénitialiser",
                          ),
                        ),
                        _spacer,
                      ],
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
