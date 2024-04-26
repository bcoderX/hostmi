import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/core/utils/image_constant.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_icon_button.dart';
import 'package:hostmi/widgets/custom_image_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api/constants/version.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        elevation: 0.0,
        foregroundColor: Colors.black,
        title: const Text("A propos"),
      ),
      backgroundColor: AppColor.grey,
      body: Scrollbar(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    "Hostmi v$version",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (context.watch<HostmiProvider>().hasUpdates)
                    Text(
                      "(v${context.read<HostmiProvider>().update!.version} disponible)",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  const Text(
                    "Merci à vous d'utiliser Hostmi.\nVous pouvez nous joindre avec\nles contacts ci-dessous.",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: getPadding(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconButton(
                          height: 55,
                          width: 55,
                          margin: getMargin(top: 2, bottom: 2),
                          variant: IconButtonVariant.OutlineBluegray50_1,
                          padding: IconButtonPadding.PaddingAll12,
                          child: const Icon(
                            Icons.mail_outline,
                            color: AppColor.primary,
                            size: 20,
                          ),
                          onTap: () async {
                            final canOpenUrl = await canLaunchUrl(
                                Uri.parse("mailto:hostmi2023@gmail.com"));
                            if (canOpenUrl) {
                              await launchUrl(
                                  Uri.parse("mailto:hostmi2023@gmail.com"));
                            }
                          },
                        ),
                        CustomIconButton(
                            onTap: () async {
                              final canOpenUrl = await canLaunchUrl(
                                  Uri.parse("tel:+22664260325"));
                              if (canOpenUrl) {
                                await launchUrl(Uri.parse("tel:+22664260325"));
                              }
                            },
                            height: 55,
                            width: 55,
                            margin: getMargin(left: 3, top: 2, bottom: 2),
                            variant: IconButtonVariant.OutlineBluegray50_1,
                            padding: IconButtonPadding.PaddingAll12,
                            child: const Icon(
                              Icons.call,
                              color: AppColor.primary,
                              size: 20,
                            )),
                        CustomIconButton(
                          height: 55,
                          width: 55,
                          margin: getMargin(left: 3, top: 2, bottom: 2),
                          variant: IconButtonVariant.OutlineBluegray50_1,
                          padding: IconButtonPadding.PaddingAll12,
                          child: CustomImageView(
                              svgPath: ImageConstant.imgWhatsapp),
                          onTap: () async {
                            final canOpenUrl = await canLaunchUrl(
                                Uri.parse("https://wa.me/22664260325"));
                            if (canOpenUrl) {
                              await launchUrl(
                                  Uri.parse("https://wa.me/22664260325"));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  context.watch<HostmiProvider>().hasUpdates
                      ? CustomButton(
                          onTap: () async {
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
                          text: " Mettre à jour ",
                          shape: ButtonShape.RoundedBorder10,
                          variant: ButtonVariant.FillBluegray50,
                          fontStyle: ButtonFontStyle.ManropeSemiBold16Gray900,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
