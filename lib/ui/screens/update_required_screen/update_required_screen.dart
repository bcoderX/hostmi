import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RequiredUpdateScreen extends StatelessWidget {
  const RequiredUpdateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if ((currentBackPressTime == null ||
                now.difference(currentBackPressTime!) >
                    const Duration(seconds: 2)) &&
            !rootNavigatorKey.currentState!.context.canPop()) {
          currentBackPressTime = now;
          Fluttertoast.showToast(
              msg: "Appuyer encore une fois pour quitter",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Image.asset(
                "assets/images/update.png",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: getPadding(left: 26, top: 40, right: 26, bottom: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: AppDecoration.txtOutlineBlack9003f,
                    child: Text(
                      "Mise à jour disponible",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: getFontSize(30),
                      ),
                    ),
                  ),
                  Container(
                    margin: getMargin(all: 15),
                    child: Text(
                      "Nous avons lancé une nouvelle version importante de Hostmi.  Veuillez mettre à jour votre application pour profiter de nos services.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: getFontSize(18)),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          foregroundColor: AppColor.white,
                          elevation: 0.0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                        onPressed: () async {
                          String url = Platform.isAndroid
                              ? context
                                  .read<HostmiProvider>()
                                  .update!
                                  .androidLink!
                              : Platform.isIOS
                                  ? context
                                      .read<HostmiProvider>()
                                      .update!
                                      .iosLink!
                                  : "";
                          Uri link = Uri.parse(url);
                          bool canLaunch = await canLaunchUrl(link);
                          if (canLaunch) {
                            launchUrl(link);
                          }
                        },
                        child: const Text("Mettre à jour")),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
