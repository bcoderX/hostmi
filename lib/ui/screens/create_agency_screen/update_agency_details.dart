import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/rest/agencies/update_agency.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/utils/color_constant.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/theme/app_style.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/screens/loading_page.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_drop_down.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

class UpdateAgencyDetails extends StatefulWidget {
  const UpdateAgencyDetails({super.key});

  @override
  State<UpdateAgencyDetails> createState() => _UpdateAgencyDetailsState();
}

class _UpdateAgencyDetailsState extends State<UpdateAgencyDetails> {
  late Future<List<AgencyModel?>> _future;

  final GlobalKey<FormState> _formState = GlobalKey();

  bool _isCreating = false;

  final SizedBox _spacer = const SizedBox(height: 25.0);

  PhoneNumber phone = PhoneNumber(isoCode: 'BF');

  PhoneNumber whatsapp = PhoneNumber(isoCode: 'BF');

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _citiesController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _future = getAgencyDetails().then((value) {
      if (value.isEmpty) {
        context.push(keyCreateAgencyRoute);
      }

      if (value[0]!.phoneNumber != null) {
        PhoneNumber.getRegionInfoFromPhoneNumber(value[0]!.phoneNumber!)
            .then((value) {
          phone = value;
        });
      }
      if (value[0]!.whatsapp != null) {
        PhoneNumber.getRegionInfoFromPhoneNumber(value[0]!.whatsapp!)
            .then((value) {
          whatsapp = value;
        });
      }

      _nameController.text = value[0]!.name!;
      _descriptionController.text = value[0]!.description!;
      _emailController.text = value[0]!.email!;
      _addressController.text = value[0]!.address!;
      _citiesController.text = value[0]!.cities!;

      return value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (supabase.auth.currentUser == null) {
      return Center(
        child: InkWell(
          onTap: () {
            context.push(keyLoginRoute);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text("Connectez vous à votre compte"),
              TextButton(
                child: const Text("Cliquer ici pour se connecter"),
                onPressed: () {
                  context.push(keyLoginRoute);
                },
              ),
            ],
          ),
        ),
      );
    }

    return FutureBuilder<List<AgencyModel?>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Une erreur s'est produite. Recharger la page"),
                  IconButton(
                      onPressed: () {
                        _future = getAgencyDetails().whenComplete(() {
                          setState(() {});
                        });
                      },
                      icon: const Icon(
                        Icons.replay_circle_filled_rounded,
                        size: 40,
                        color: AppColor.primary,
                      ))
                ],
              ),
            ));
          }
          if (!snapshot.hasData) {
            return const BallLoadingPage(
              loadingTitle: "Recherche de votre agence...",
            );
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const SizedBox();
          } else if (snapshot.hasData &&
              snapshot.data!.isNotEmpty &&
              snapshot.data![0] == null) {
            return Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(25.0),
                    child:
                        Text("Vérifier votre connexion internet et réessayer:"),
                  ),
                  IconButton(
                      onPressed: () {
                        _future = getAgencyDetails();
                      },
                      icon: const Icon(
                        Icons.replay_circle_filled_rounded,
                        size: 40,
                        color: AppColor.primary,
                      ))
                ],
              ),
            ));
          }

          return _isCreating
              ? const BallLoadingPage(loadingTitle: "Mise à jour de la page")
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: AppColor.grey,
                    foregroundColor: AppColor.black,
                    elevation: 0.0,
                    title: const Text(
                      "Mettre à jour l'agence",
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
                        ),
                      ),
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
                            Padding(
                                padding: getPadding(top: 17),
                                child: Text("Nom de l'agence",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtManropeMedium16.copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.4)))),
                            CustomTextFormField(
                              controller: _nameController,
                              margin: getMargin(top: 7),
                              padding: TextFormFieldPadding.PaddingAll16,
                              hintText: "EX: HostMI",
                              validator: (value) {
                                if (value!.trim().isEmpty ||
                                    value.trim().length < 3) {
                                  return "Saisir un nom d'au moins trois lettres";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Padding(
                                padding: getPadding(top: 17),
                                child: Text("Pays",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtManropeMedium16.copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.4)))),
                            CustomDropDown(
                              value: context
                                  .read<HostmiProvider>()
                                  .agencyCountryId,
                              margin: getMargin(top: 7),
                              variant: DropDownVariant.FillBluegray50,
                              fontStyle:
                                  DropDownFontStyle.ManropeMedium14Bluegray500,
                              items: context
                                  .watch<HostmiProvider>()
                                  .countriesList
                                  .map((country) {
                                return DropdownMenuItem<String>(
                                    value: country["id"].toString(),
                                    child: Text(
                                      country["fr"].toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ));
                              }).toList(),
                              onChanged: (String? value) {
                                List<dynamic> countries = context
                                    .read<HostmiProvider>()
                                    .countriesList;
                                int id = countries.indexWhere((element) =>
                                    element["id"].toString() == value);
                                context.read<HostmiProvider>().setAgencyCountry(
                                    value!, countries[id]["fr"]);
                              },
                            ),
                            Padding(
                                padding: getPadding(top: 17),
                                child: Text("Description",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtManropeMedium16.copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.4)))),
                            CustomTextFormField(
                              controller: _descriptionController,
                              margin: getMargin(top: 7),
                              padding: TextFormFieldPadding.PaddingAll16,
                              maxLines: 4,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Saisir une petite description de votre agence";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Padding(
                                padding: getPadding(top: 17),
                                child: Text(
                                    AppLocalizations.of(context)!.phoneNumber,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtManropeMedium16.copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.4)))),
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
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              selectorTextStyle:
                                  const TextStyle(color: Colors.black),
                              initialValue: phone,
                              formatInput: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false, decimal: false),
                            ),
                            Padding(
                                padding: getPadding(top: 17),
                                child: Text("Numéro WhatsApp",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtManropeMedium16.copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.4)))),
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
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              selectorTextStyle:
                                  const TextStyle(color: Colors.black),
                              initialValue: whatsapp,
                              formatInput: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false, decimal: false),
                            ),
                            Padding(
                                padding: getPadding(top: 17),
                                child: Text("Email",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtManropeMedium16.copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.4)))),
                            CustomTextFormField(
                              controller: _emailController,
                              margin: getMargin(top: 7),
                              padding: TextFormFieldPadding.PaddingAll16,
                              textInputType: TextInputType.emailAddress,
                              hintText: "example@email.com",
                              validator: (value) {
                                if (value!.trim().isEmpty ||
                                    value.trim().length < 4) {
                                  return "Veuillez saisir votre Email";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Padding(
                                padding: getPadding(top: 17),
                                child: Text("Addresse",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtManropeMedium16.copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.4)))),
                            CustomTextFormField(
                              controller: _addressController,
                              margin: getMargin(top: 7),
                              padding: TextFormFieldPadding.PaddingAll16,
                              textInputType: TextInputType.streetAddress,
                              hintText:
                                  "000 Avenue de la nation 01 BP 300 Koudougou",
                              validator: (value) {
                                if (value!.trim().isEmpty ||
                                    value.trim().length < 9) {
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
                                    style: AppStyle.txtManropeMedium16.copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.4)))),
                            CustomTextFormField(
                              controller: _citiesController,
                              margin: getMargin(top: 7),
                              padding: TextFormFieldPadding.PaddingAll16,
                              textInputType: TextInputType.text,
                              hintText: AppLocalizations.of(context)!
                                  .coveredTownsHint,
                              validator: (value) {
                                if (value!.trim().isEmpty ||
                                    value.trim().length < 2) {
                                  return "Veuillez saisir des villes valides";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            _spacer,
                            CustomButton(
                              onTap: _isCreating
                                  ? null
                                  : () {
                                      if (_formState.currentState!.validate()) {
                                        _createNewAgency(
                                            context, snapshot.data![0]!.id!);
                                      }
                                    },
                              height: getVerticalSize(56),
                              text: "Mettre à jour",
                              shape: ButtonShape.RoundedBorder10,
                              padding: ButtonPadding.PaddingAll16,
                              fontStyle:
                                  ButtonFontStyle.ManropeBold16WhiteA700_1,
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
                );
        });
  }

  Future<void> _createNewAgency(BuildContext context, String id) async {
    context.read<HostmiProvider>().setAgencyName(_nameController.text.trim());
    context
        .read<HostmiProvider>()
        .setAgencyDescription(_descriptionController.text.trim());
    context.read<HostmiProvider>().setAgencyPhone(phone.phoneNumber!);
    context.read<HostmiProvider>().setAgencyWhatsApp(whatsapp.phoneNumber!);
    context.read<HostmiProvider>().setAgencyEmail(_emailController.text.trim());
    context
        .read<HostmiProvider>()
        .setAgencyAddress(_addressController.text.trim());
    context
        .read<HostmiProvider>()
        .setAgencyPlace(_citiesController.text.trim());
    setState(() {
      _isCreating = true;
    });
    final AgencyModel agency = AgencyModel(
        id: id,
        countryId: int.parse(context.read<HostmiProvider>().agencyCountryId),
        createdBy: supabase.auth.currentUser!.id,
        name: context.read<HostmiProvider>().agencyName,
        description: context.read<HostmiProvider>().agencyDescription,
        phoneNumber: context.read<HostmiProvider>().agencyPhone,
        whatsapp: context.read<HostmiProvider>().agencyWhatsapp,
        cities: context.read<HostmiProvider>().agencyTowns,
        address: context.read<HostmiProvider>().agencyAdress,
        email: context.read<HostmiProvider>().agencyEmail);
    final result = await updateAgency(agency);

    if (result.isNotEmpty) {
      _isCreating = false;
      if (result[0]["name"] == agency.name) {
        AgencyModel agencyModel = AgencyModel.fromMap(result[0]);
        setAgencyDetails(agencyModel);
        setState(() {
          _isCreating = false;
          context.go(keyPublishRoute);
        });
      }
    } else {
      setState(() {
        _isCreating = false;
      });

      _showErrorDialog();
    }
  }

  _showErrorDialog() {
    showErrorDialog(
      title: "Echec de la mise à jour",
      content: "Nous n'avons pas réussi la mise à jour de votre page.",
      context: context,
    );
  }
}
