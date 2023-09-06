import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/api/providers/locale_provider.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String? radioGroup = "";

  @override
  Widget build(BuildContext context) {
    radioGroup = context.watch<LocaleProvider>().locale == null
        ? "auto"
        : AppLocalizations.of(context)?.localeName;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        title: const Text(
          "Language",
          style: TextStyle(
            color: AppColor.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: getPadding(
              left: 8,
            ),
            child: CustomRadioButton(
              text: "System Language",
              value: "auto",
              groupValue: radioGroup,
              margin: getMargin(left: 8, top: 18),
              fontStyle: RadioFontStyle.ManropeMedium14Gray900,
              onChange: (value) {
                context.read<LocaleProvider>().set(null);
                setState(() {
                  radioGroup = value;
                });
              },
            ),
          ),
          Padding(
            padding: getPadding(
              left: 8,
            ),
            child: CustomRadioButton(
              text: "English",
              value: "en",
              groupValue: radioGroup,
              margin: getMargin(left: 8, top: 18),
              fontStyle: RadioFontStyle.ManropeMedium14Gray900,
              onChange: (value) {
                context.read<LocaleProvider>().set(const Locale("en"));
                setState(() {
                  radioGroup = value;
                });
              },
            ),
          ),
          Padding(
            padding: getPadding(
              left: 8,
            ),
            child: CustomRadioButton(
              text: "Français",
              value: "fr",
              groupValue: radioGroup,
              margin: getMargin(left: 8, top: 18),
              fontStyle: RadioFontStyle.ManropeMedium14Gray900,
              onChange: (value) {
                context.read<LocaleProvider>().set(const Locale("fr"));
                setState(() {
                  radioGroup = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
