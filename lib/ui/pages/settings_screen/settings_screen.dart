import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/providers/locale_provider.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/pages/faqs_get_help_screen/faqs_get_help_screen.dart';
import 'package:hostmi/ui/pages/profile_page/profile_page.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_switch.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSelectedSwitch = false;
  bool isSelectedSwitch1 = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                          Container(
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: const [
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
                          ),
                          Text("Application menu",
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
                                        child: Text("Notification",
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
                                        padding: getPadding(top: 2, bottom: 1),
                                        child: Text("Dark Mode",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeSemiBold14Gray900)),
                                    CustomSwitch(
                                        value: isSelectedSwitch1,
                                        onChanged: (value) {
                                          setState(() {
                                            isSelectedSwitch1 = value;
                                          });
                                        })
                                  ])),
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
                                      child: Text("Language",
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
                                    child: Text("Country",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeSemiBold14Gray900)),
                                const Spacer(),
                                Padding(
                                    padding: getPadding(bottom: 1),
                                    child: Text("Burkina Faso",
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
                                          ProfilePage()));
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
                                    Text("Terms of use",
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
                                        child: Text("Privacy Policy",
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
                                        child: Text("About",
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
                                      ])))
                        ])),
              ),
            )));
  }

  onTapFaqs(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (BuildContext context) => FaqsGetHelpScreen()));
  }

  onTapArrowleft16(BuildContext context) {
    Navigator.pop(context);
  }
}
