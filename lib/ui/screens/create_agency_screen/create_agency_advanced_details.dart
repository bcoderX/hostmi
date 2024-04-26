import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/core/utils/color_constant.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/theme/app_style.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class CreateAgencyAdvancedDetails extends StatefulWidget {
  const CreateAgencyAdvancedDetails({Key? key}) : super(key: key);

  @override
  State<CreateAgencyAdvancedDetails> createState() =>
      _CreateAgencyAdvancedDetailsState();
}

class _CreateAgencyAdvancedDetailsState
    extends State<CreateAgencyAdvancedDetails> {
  final _formState = GlobalKey<FormState>();

  final SizedBox _spacer = const SizedBox(height: 25.0);

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _citiesController = TextEditingController();

  PhoneNumber phone = PhoneNumber(isoCode: 'BF');

  PhoneNumber whatsapp = PhoneNumber(isoCode: 'BF');
  @override
  void initState() {
    _emailController.text = context.read<HostmiProvider>().agencyEmail;
    _addressController.text = context.read<HostmiProvider>().agencyAdress;
    _citiesController.text = context.read<HostmiProvider>().agencyTowns;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        title: const Text(
          "Créer une agence",
          style: TextStyle(
            color: AppColor.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.person,
                color: AppColor.primary,
              ))
        ],
      ),
      body: Scrollbar(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _spacer,
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Dites-nous comment contacter ${context.read<HostmiProvider>().agencyName}",
                    style: const TextStyle(
                      color: AppColor.primary,
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                    padding: getPadding(top: 17),
                    child: Text(AppLocalizations.of(context)!.phoneNumber,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeMedium16
                            .copyWith(letterSpacing: getHorizontalSize(0.4)))),
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
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: phone,
                  formatInput: true,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                ),
                Padding(
                    padding: getPadding(top: 17),
                    child: Text("Numéro WhatsApp",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeMedium16
                            .copyWith(letterSpacing: getHorizontalSize(0.4)))),
                InternationalPhoneNumberInput(
                  errorMessage: "Numéro whatsapp incorrect",
                  onInputChanged: (PhoneNumber number) {
                    print(number.phoneNumber);
                    whatsapp = number;
                  },
                  onInputValidated: (bool value) {
                    print(value);
                  },
                  inputDecoration: InputDecoration(
                      contentPadding: getPadding(),
                      filled: true,
                      fillColor: ColorConstant.blueGray50,
                      hintText: "Numéro whatsapp",
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
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  selectorTextStyle: const TextStyle(color: Colors.black),
                  initialValue: whatsapp,
                  formatInput: true,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: false, decimal: false),
                ),
                Padding(
                    padding: getPadding(top: 17),
                    child: Text("Email",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeMedium16
                            .copyWith(letterSpacing: getHorizontalSize(0.4)))),
                CustomTextFormField(
                  controller: _emailController,
                  margin: getMargin(top: 7),
                  padding: TextFormFieldPadding.PaddingAll16,
                  textInputType: TextInputType.emailAddress,
                  hintText: "example@email.com",
                  validator: (value) {
                    final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value ?? "");
                    if (emailValid) {
                      return null;
                    }
                    return "Email incorrect";
                  },
                ),
                Padding(
                    padding: getPadding(top: 17),
                    child: Text("Addresse",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeMedium16
                            .copyWith(letterSpacing: getHorizontalSize(0.4)))),
                CustomTextFormField(
                  controller: _addressController,
                  margin: getMargin(top: 7),
                  padding: TextFormFieldPadding.PaddingAll16,
                  textInputType: TextInputType.streetAddress,
                  hintText: "000 Avenue de la nation 01 BP 160 Koudougou",
                  validator: (value) {
                    if (value!.trim().isEmpty || value.trim().length < 9) {
                      return "Veuillez saisir une addresse valide";
                    } else {
                      return null;
                    }
                  },
                ),
                Padding(
                    padding: getPadding(top: 17),
                    child: Text("Villes",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeMedium16
                            .copyWith(letterSpacing: getHorizontalSize(0.4)))),
                CustomTextFormField(
                  controller: _citiesController,
                  margin: getMargin(top: 7),
                  padding: TextFormFieldPadding.PaddingAll16,
                  textInputType: TextInputType.text,
                  hintText: AppLocalizations.of(context)!.coveredTownsHint,
                  validator: (value) {
                    if (value!.trim().isEmpty || value.trim().length < 2) {
                      return "Veuillez saisir des villes valides";
                    } else {
                      return null;
                    }
                  },
                ),
                _spacer,
                CustomButton(
                  onTap: () {
                    if (_formState.currentState!.validate()) {
                      context
                          .read<HostmiProvider>()
                          .setAgencyPhone(phone.phoneNumber!);
                      context
                          .read<HostmiProvider>()
                          .setAgencyWhatsApp(whatsapp.phoneNumber!);
                      context
                          .read<HostmiProvider>()
                          .setAgencyEmail(_emailController.text.trim());
                      context
                          .read<HostmiProvider>()
                          .setAgencyAddress(_addressController.text.trim());
                      context
                          .read<HostmiProvider>()
                          .setAgencyPlace(_citiesController.text.trim());
                      context.push(
                          "$keyCreateAgencyRoute/$keyReviewAgencyDetailsRoute");
                    }
                  },
                  height: getVerticalSize(56),
                  text: "Vérifier et créer",
                  shape: ButtonShape.RoundedBorder10,
                  padding: ButtonPadding.PaddingAll16,
                  fontStyle: ButtonFontStyle.ManropeBold16WhiteA700_1,
                  suffixWidget: const Icon(
                    Icons.keyboard_arrow_right_outlined,
                    size: 20.0,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
