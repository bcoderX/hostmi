import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/providers/locale_provider.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/screens/faqs_get_help_screen/faqs_get_help_screen.dart';
import 'package:hostmi/ui/screens/profile_screen/profile_screen.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_switch.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSelectedSwitch = false;
  bool isSelectedSwitch1 = false;
  bool _isDisconnecting = false;

  // late final StreamSubscription<AuthState> _authStateSubscription;
  @override
  void initState() {
    // _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
    //   if (_isDisconnecting) return;
    //   final session = data.session;
    //   if (session == null) {
    //     _isDisconnecting = false;
    //     hostmiBox.clear();
    //     context.go("/");
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isDisconnecting
        ? Scaffold(
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
                    const Text(
                      "Déconnexion en cours\nVeuillez patienter...",
                      textAlign: TextAlign.center,
                    ),
                  ]),
            ),
          )
        : Scaffold(
            backgroundColor: ColorConstant.gray50,
            appBar: AppBar(
              title: const Text("Menu"),
              backgroundColor: AppColor.grey,
              foregroundColor: AppColor.black,
              elevation: 0.0,
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
            body: Scrollbar(
              child: SingleChildScrollView(
                child: Container(
                    width: double.maxFinite,
                    padding: getPadding(left: 8, top: 34, right: 8, bottom: 34),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /* Container(
                        width: double.infinity,
                        height: 150,
                        margin: getMargin(bottom: 20),
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: ColorConstant.brown500,
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all()),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Account balance",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle
                                    .txtManropeExtraBold14Bluegray500
                                    .copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.2),
                                        color: AppColor.white)),
                            const SizedBox(
                              height: 20,
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.credit_card,
                                  color: AppColor.white,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  "2 000 XOF",
                                  style: TextStyle(
                                    color: AppColor.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.white,
                                      ),
                                      onPressed: () {},
                                      child: const Text(
                                        "Transaction history",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColor.black,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.white,
                                      ),
                                      onPressed: () {},
                                      child: const Text(
                                        "Replenish",
                                        style: TextStyle(
                                          color: AppColor.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ), */
                          Text("Menu de l'application",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeExtraBold14Bluegray500
                                  .copyWith(
                                      letterSpacing: getHorizontalSize(0.2))),
                          Padding(
                              padding: getPadding(top: 14),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: getPadding(top: 2, bottom: 1),
                                        child: Text("Notifications",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeSemiBold14Gray900)),
                                    CustomSwitch(
                                        value: isSelectedSwitch,
                                        onChanged: (value) {
                                          setState(() {
                                            isSelectedSwitch = value;
                                          });
                                        })
                                  ])),
                          //Night mode
                          // Padding(
                          //     padding: getPadding(top: 16),
                          //     child: Divider(
                          //         height: getVerticalSize(1),
                          //         thickness: getVerticalSize(1),
                          //         color: ColorConstant.gray300)),
                          // Padding(
                          //     padding: getPadding(top: 15),
                          //     child: Row(
                          //         mainAxisAlignment:
                          //             MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Padding(
                          //               padding: getPadding(top: 2, bottom: 1),
                          //               child: Text("Mode nuit",
                          //                   overflow: TextOverflow.ellipsis,
                          //                   textAlign: TextAlign.left,
                          //                   style: AppStyle
                          //                       .txtManropeSemiBold14Gray900)),
                          //           CustomSwitch(
                          //               value: isSelectedSwitch1,
                          //               onChanged: (value) {
                          //                 setState(() {
                          //                   isSelectedSwitch1 = value;
                          //                 });
                          //               })
                          //         ])),
                          Padding(
                            padding: getPadding(top: 16),
                            child: Divider(
                                height: getVerticalSize(1),
                                thickness: getVerticalSize(1),
                                color: ColorConstant.gray300),
                          ),
                          InkWell(
                            onTap: () {
                              context.go("/settings/language/");
                            },
                            child: Padding(
                                padding: getPadding(top: 15),
                                child: Row(children: [
                                  Padding(
                                      padding: getPadding(top: 3),
                                      child: Text("Langue",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtManropeSemiBold14Gray900)),
                                  const Spacer(),
                                  Padding(
                                      padding: getPadding(top: 2, bottom: 1),
                                      child: Text(
                                          context
                                                  .read<LocaleProvider>()
                                                  .supportedLocales[
                                              AppLocalizations.of(context)
                                                  ?.localeName]!,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style:
                                              AppStyle.txtManropeSemiBold14)),
                                  CustomImageView(
                                      svgPath: ImageConstant
                                          .imgArrowrightBlueGray500,
                                      height: getSize(20),
                                      width: getSize(20),
                                      margin: getMargin(left: 4, bottom: 3))
                                ])),
                          ),
                          Padding(
                              padding: getPadding(top: 16),
                              child: Divider(
                                  height: getVerticalSize(1),
                                  thickness: getVerticalSize(1),
                                  color: ColorConstant.gray300)),
                          Padding(
                              padding: getPadding(top: 15),
                              child: Row(children: [
                                Padding(
                                    padding: getPadding(top: 2),
                                    child: Text("Pays",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeSemiBold14Gray900)),
                                const Spacer(),
                                Padding(
                                    padding: getPadding(bottom: 1),
                                    child: Text(
                                        supabase.auth.currentSession == null
                                            ? "---"
                                            : "Burkina Faso",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtManropeSemiBold14)),
                                CustomImageView(
                                    svgPath:
                                        ImageConstant.imgArrowrightBlueGray500,
                                    height: getSize(20),
                                    width: getSize(20),
                                    margin: getMargin(left: 4, bottom: 2))
                              ])),
                          Padding(
                              padding: getPadding(top: 14),
                              child: Divider(
                                  height: getVerticalSize(1),
                                  thickness: getVerticalSize(1),
                                  color: ColorConstant.gray300)),
                          InkWell(
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const ProfilePage()));
                            },
                            child: Padding(
                                padding: getPadding(top: 15),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: getPadding(top: 1),
                                          child: Text("Profile",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtManropeSemiBold14Gray900)),
                                      CustomImageView(
                                          svgPath:
                                              ImageConstant.imgArrowright20x20,
                                          height: getSize(20),
                                          width: getSize(20),
                                          margin: getMargin(bottom: 1))
                                    ])),
                          ),
                          Padding(
                              padding: getPadding(top: 33),
                              child: Text("Support",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle
                                      .txtManropeExtraBold14Bluegray500
                                      .copyWith(
                                          letterSpacing:
                                              getHorizontalSize(0.2)))),
                          Padding(
                              padding: getPadding(top: 14),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Condiditions d'utilistion",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeSemiBold14Gray900),
                                    CustomImageView(
                                        svgPath:
                                            ImageConstant.imgArrowright20x20,
                                        height: getSize(20),
                                        width: getSize(20))
                                  ])),
                          Padding(
                              padding: getPadding(top: 16),
                              child: Divider(
                                  height: getVerticalSize(1),
                                  thickness: getVerticalSize(1),
                                  color: ColorConstant.gray300)),
                          Padding(
                              padding: getPadding(top: 15),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: getPadding(top: 2),
                                        child: Text(
                                            "Politiques de confidentialité",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeSemiBold14Gray900)),
                                    CustomImageView(
                                        svgPath:
                                            ImageConstant.imgArrowright20x20,
                                        height: getSize(20),
                                        width: getSize(20),
                                        margin: getMargin(bottom: 2))
                                  ])),
                          Padding(
                              padding: getPadding(top: 14),
                              child: Divider(
                                  height: getVerticalSize(1),
                                  thickness: getVerticalSize(1),
                                  color: ColorConstant.gray300)),
                          Padding(
                              padding: getPadding(top: 15),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                        padding: getPadding(top: 1),
                                        child: Text("A propos",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeSemiBold14Gray900)),
                                    CustomImageView(
                                        svgPath:
                                            ImageConstant.imgArrowright20x20,
                                        height: getSize(20),
                                        width: getSize(20),
                                        margin: getMargin(bottom: 1))
                                  ])),
                          Padding(
                              padding: getPadding(top: 15),
                              child: Divider(
                                  height: getVerticalSize(1),
                                  thickness: getVerticalSize(1),
                                  color: ColorConstant.gray300)),
                          InkWell(
                              onTap: () {
                                onTapFaqs(context);
                              },
                              child: Padding(
                                  padding: getPadding(top: 15, bottom: 5),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("FAQs",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeSemiBold14Gray900),
                                        CustomImageView(
                                            svgPath: ImageConstant
                                                .imgArrowright20x20,
                                            height: getSize(20),
                                            width: getSize(20))
                                      ]))),
                          Padding(
                              padding: getPadding(top: 15),
                              child: Divider(
                                  height: getVerticalSize(1),
                                  thickness: getVerticalSize(1),
                                  color: ColorConstant.gray300)),
                          InkWell(
                              onTap: () {
                                if (supabase.auth.currentSession == null) {
                                  context.go("/login");
                                } else {
                                  supabase.auth.onAuthStateChange
                                      .listen((data) {
                                    if (_isDisconnecting) return;
                                    final session = data.session;
                                    if (session == null) {
                                      _isDisconnecting = false;
                                      hostmiBox.clear();
                                      context.go("/");
                                    }
                                  });
                                  try {
                                    setState(() {
                                      _isDisconnecting = true;
                                    });
                                    supabase.auth.signOut();
                                  } on AuthException catch (error) {
                                    if (error.statusCode == '400') {
                                      _loginErrorDialog(
                                        title: "Problème de déconnexion",
                                        content: "Veuillez réessayer",
                                      );
                                    }
                                  } catch (error) {
                                    print(error);
                                    _loginErrorDialog(
                                      title: "Problème de connexion",
                                      content:
                                          "Vérifiez votre connexion internet et réessayer.",
                                    );
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isDisconnecting = false;
                                      });
                                    }
                                  }
                                }

                                // context.go("/");
                              },
                              child: Padding(
                                  padding: getPadding(top: 15, bottom: 5),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            supabase.auth.currentSession == null
                                                ? "Se connecter"
                                                : "Se déconnecter",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: supabase
                                                        .auth.currentSession ==
                                                    null
                                                ? TextStyle(
                                                    fontSize: getFontSize(16),
                                                    color: AppColor.primary)
                                                : AppStyle
                                                    .txtManropeSemiBold16Brown500),
                                      ])))
                        ])),
              ),
            ));
  }

  onTapFaqs(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (BuildContext context) => FaqsGetHelpScreen()));
  }

  onTapArrowleft16(BuildContext context) {
    Navigator.pop(context);
  }

  _loginErrorDialog({required String title, required String content}) {
    showErrorDialog(
      title: title,
      content: content,
      context: context,
    );
  }
}
