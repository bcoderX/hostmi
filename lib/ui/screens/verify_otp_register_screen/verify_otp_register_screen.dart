import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/constants/roles.dart';
import 'package:hostmi/api/firebase/analytics_client.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/rest/users/is_profile_completed.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:supabase/supabase.dart';

class VerifyOTPRegisterScreen extends StatefulWidget {
  const VerifyOTPRegisterScreen({super.key, this.phoneNumber, this.email});
  final String? phoneNumber;
  final String? email;

  @override
  State<VerifyOTPRegisterScreen> createState() =>
      _VerifyOTPRegisterScreenState();
}

class _VerifyOTPRegisterScreenState extends State<VerifyOTPRegisterScreen> {
  bool _isLoading = false;
  bool _redirecting = false;
  bool canResend = false;
  Role role = getRole();
  late final TextEditingController _codeController;
  final GlobalKey<FormState> _formState = GlobalKey();
  late final StreamSubscription<AuthState> _authStateSubscription;
  Future<void> _verifyOtp() async {
    try {
      setState(() {
        _isLoading = true;
      });
      debugPrint(_codeController.text);
      AuthResponse response = widget.email == null ? await supabase.auth.verifyOTP(
        phone: widget.phoneNumber,
        token: _codeController.text,
        type: OtpType.sms,
      ): await supabase.auth.verifyOTP(
        email: widget.email,
        token: _codeController.text,
        type: OtpType.signup,
      );
      debugPrint((response.session == null).toString());
    } on AuthException catch (error) {
      if (error.statusCode == '400') {
        _loginErrorDialog(
          title: "Problème de connexion",
          content: widget.email == null ? "Vérifiez votre email ou votre code.":"Vérifiez votre code ou votre numéro de téléphone.",
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

  _resendOtp() async {
    if (canResend) {
      setState(() {
        canResend = false;
      });
      if (widget.phoneNumber != null) {
        try {
          FunctionResponse res = await supabase.functions.invoke(
            "auth",
            body: {
              "operation": "resend",
              "phone": widget.phoneNumber,
            },
          );
          if (res.data["success"]) {
            setState(() {
              canResend = false;
            });
            analytics.logEvent(name: "Resend OTP", parameters: {"type": widget.email==null ? "Phone" : "Email"});
          } else if (res.data["message"] == "User not registered") {
            _loginErrorDialog(
              title: "Utilisateur non trouvé",
              content:
                  "Il semble qu'il n'y ait aucun compte associé à ce numéro de téléphone. Veuillez vous rendre dans la page de création de compte",
            );
          } else {
            setState(() {
              canResend = true;
            });
            _loginErrorDialog(
              title: "Erreur",
              content: "Echec de l'envoi du message. Veuillez réessayer.",
            );
          }
        } catch (e) {
          setState(() {
            canResend = true;
          });
          _loginErrorDialog(
            title: "Problème de connexion",
            content: "Vérifiez votre connexion internet et réessayer.",
          );
        }
      } else {
        try {
          await supabase.auth.resend(type: OtpType.signup, email: widget.email);
        } catch (e) {
          setState(() {
            canResend = true;
          });
          _loginErrorDialog(
            title: "Problème de connexion",
            content: "Vérifiez votre connexion internet et réessayer.",
          );
        }
      }

      if (!canResend) {
        Timer(const Duration(minutes: 5), () {
          setState(() {
            canResend = true;
          });
        });
      }
    } else {
      _loginErrorDialog(
        title: "Veuillez patienter",
        content:
            "Vous de patienter 5mn après un envoi réussi avant de pouvoir demander un autre code.",
      );
    }
  }

  void _navigateTo(String route) {
    context.go(route);
  }

  void _pushRoute(String route) {
    context.push(route);
  }

  @override
  void initState() {
    _codeController = TextEditingController();
    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        try{
          analytics.logSignUp(signUpMethod: widget.email==null ? "Phone": "Email", parameters: {"confirmed": "true"});
        }catch(e){
          debugPrint(e.toString());
        }
        context.read<HostmiProvider>().setIsLoggedIn(true);
        _redirecting = true;
        if (role == Role.DEVELOPER) {
          _navigateTo("/complete-profile/initial$keyPublishRoute");
        } else if (role == Role.TENANT) {
          _navigateTo("/complete-profile/initial/list");
        } else {
          _pushRoute("/choose-role/login");
        }
      }
    });
    Timer(const Duration(minutes: 5), () {
      setState(() {
        canResend = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            backgroundColor: ColorConstant.gray50,
            resizeToAvoidBottomInset: false,
            body: Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                    width: double.maxFinite,
                    padding: getPadding(left: 23, top: 8, right: 23, bottom: 8),
                    child: Form(
                      key: _formState,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const BackButton(),
                            Padding(
                                padding: getPadding(left: 1, top: 34),
                                child: Text("Valider votre identité",
                                    // overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style:
                                        AppStyle.txtManropeExtraBold24Gray900)),
                            Container(
                              margin: getMargin(left: 1, top: 7, right: 28),
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          "Nous avons envoyé un code ${widget.email == null ? 'au' : 'à'} ",
                                      style: TextStyle(
                                          color: ColorConstant.blueGray500,
                                          fontSize: getFontSize(14),
                                          fontFamily: 'Manrope',
                                          fontWeight: FontWeight.w600)),
                                  TextSpan(
                                    text:
                                        " *****${widget.phoneNumber != null ? widget.phoneNumber!.substring(widget.phoneNumber!.length - 3) : widget.email}). Saisissez le pour valider votre identité.",
                                    style: TextStyle(
                                      color: ColorConstant.gray900,
                                      fontSize: getFontSize(14),
                                      fontFamily: 'Manrope',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ]),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: getPadding(left: 1, top: 47),
                              child: PinCodeTextField(
                                validator: (value) {
                                  if (value!.length < 6) {
                                    return "Le code est incorrect";
                                  }
                                  return null;
                                },
                                controller: _codeController,
                                appContext: context,
                                length: 6,
                                obscureText: false,
                                keyboardType: TextInputType.number,
                                autoDismissKeyboard: true,
                                enableActiveFill: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (value) {},
                                textStyle: TextStyle(
                                    color: ColorConstant.gray900,
                                    fontSize: getFontSize(24),
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.w800),
                                pinTheme: PinTheme(
                                  fieldHeight: screenSize.width * 0.13,
                                  fieldWidth: screenSize.width * 0.13,
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(
                                      getHorizontalSize(12)),
                                  selectedFillColor: ColorConstant.blueGray50,
                                  activeFillColor: ColorConstant.blueGray50,
                                  inactiveFillColor: ColorConstant.blueGray50,
                                  inactiveColor:
                                      ColorConstant.fromHex("#1212121D"),
                                  selectedColor:
                                      ColorConstant.fromHex("#1212121D"),
                                  activeColor:
                                      ColorConstant.fromHex("#1212121D"),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: !canResend
                                  ? null
                                  : InkWell(
                                      onTap: _resendOtp,
                                      child: Padding(
                                        padding: getPadding(top: 33),
                                        child: Text(
                                          "Renvoyer le Code",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtManropeSemiBold16Brown500
                                              .copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.2),
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            CustomButton(
                                height: getVerticalSize(56),
                                text: _isLoading
                                    ? "Veuillez patientez..."
                                    : "Confirmer",
                                margin: getMargin(left: 1, top: 50, bottom: 5),
                                shape: ButtonShape.RoundedBorder10,
                                padding: ButtonPadding.PaddingAll16,
                                fontStyle:
                                    ButtonFontStyle.ManropeBold16WhiteA700_1,
                                onTap: () {
                                  onTapConfirm(context);
                                })
                          ]),
                    )),
              ),
            )));
  }

  onTapBtnArrowleft(BuildContext context) {
    Navigator.pop(context);
  }

  onTapConfirm(BuildContext context) {
    _verifyOtp();
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (BuildContext context) {
    //   return const MainPage();
    // }));
    //Navigator.pushNamed(context, AppRoutes.selectVirtualAppScreen);
  }

  _loginErrorDialog({required String title, required String content}) {
    showErrorDialog(
      title: title,
      content: content,
      context: context,
    );
  }
}
