import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/rest/agencies/check_agency_name.dart';
import 'package:hostmi/api/utils/check_connection_and_do.dart';
import 'package:hostmi/api/utils/check_internet_status.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/alerts/error_dialog.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_drop_down.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class CreateAgencyBasicDetails extends StatefulWidget {
  const CreateAgencyBasicDetails({Key? key}) : super(key: key);

  @override
  State<CreateAgencyBasicDetails> createState() =>
      _CreateAgencyBasicDetailsState();
}

class _CreateAgencyBasicDetailsState extends State<CreateAgencyBasicDetails> {
  final SizedBox _spacer = const SizedBox(height: 25.0);
  final GlobalKey<FormState> _formState = GlobalKey();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();
  bool _isCheckingName = false;

  @override
  void initState() {
    _nameController.text = context.read<HostmiProvider>().agencyName;
    _descriptionController.text =
        context.read<HostmiProvider>().agencyDescription;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      checkConnectionAndDo(() {
        context.read<HostmiProvider>().getCountries();
      });
    });

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
            Text("Vous devez créer une sorte de page que nous appelons \"Agence\" avant de publier une maison. Notre objectif est d'augmenter la visibilité de votre business. Veuillez nous fournir quelques détails de votre business dans les champs ci-dessous.",style:  TextStyle(color: Colors.grey[600])),

                Padding(
                    padding: getPadding(top: 17),
                    child: Text("Nom de l'agence",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeMedium16
                            .copyWith(letterSpacing: getHorizontalSize(0.4)))),
                CustomTextFormField(
                  controller: _nameController,
                  margin: getMargin(top: 7),
                  padding: TextFormFieldPadding.PaddingAll16,
                  hintText: "EX: HostMI",
                  maxLength: 30,
                  validator: (value) {
                    if (value!.trim().isEmpty || value.trim().length < 3) {
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
                        style: AppStyle.txtManropeMedium16
                            .copyWith(letterSpacing: getHorizontalSize(0.4)))),
                CustomDropDown(
                  value: context.read<HostmiProvider>().agencyCountryId,
                  margin: getMargin(top: 7),
                  variant: DropDownVariant.FillBluegray50,
                  fontStyle: DropDownFontStyle.ManropeMedium14Bluegray500,
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
                    List<dynamic> countries =
                        context.read<HostmiProvider>().countriesList;
                    int id = countries.indexWhere(
                        (element) => element["id"].toString() == value);
                    context
                        .read<HostmiProvider>()
                        .setAgencyCountry(value!, countries[id]["fr"]);
                  },
                ),
                Padding(
                    padding: getPadding(top: 17),
                    child: Text("Description",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeMedium16
                            .copyWith(letterSpacing: getHorizontalSize(0.4)))),
                CustomTextFormField(
                  controller: _descriptionController,
                  margin: getMargin(top: 7),
                  padding: TextFormFieldPadding.PaddingAll16,
                  maxLines: 4,
                  maxLength: 500,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Saisir une petite description de votre agence";
                    } else {
                      return null;
                    }
                  },
                ),
                _spacer,
                DefaultAppButton(
                  onPressed: () async {
                    if (_formState.currentState!.validate()) {
                      bool isConnected = await checkInternetStatus();
                      if (isConnected) {
                        setState(() {
                          _isCheckingName = true;
                        });
                        bool nameIsExisting =
                            await checkAgencyName(_nameController.text.trim());
                        if (nameIsExisting) {
                          showErrorDialog(
                              title: "Nom existant",
                              content:
                                  "Ce nom n'est pas disponible. Veuillez choisir un autre nom.",
                              context: context);
                          setState(() {
                            _isCheckingName = false;
                          });
                        } else {
                          setState(() {
                            _isCheckingName = false;
                          });

                          context
                              .read<HostmiProvider>()
                              .setAgencyName(_nameController.text.trim());
                          context.read<HostmiProvider>().setAgencyDescription(
                              _descriptionController.text.trim());
                          Timer(500.ms, () {
                            context.push(
                                "$keyCreateAgencyRoute/$keyCreateAgencyAdvancedDetailsRoute");
                          });

                        }
                      } else {
                        showErrorDialog(
                            title: "Problème de connexion",
                            content:
                                "Vérifiez votre connexion internet et rééssayez !",
                            context: context);
                      }
                    }
                  },
                  text: _isCheckingName ? "Vérication du nom..." : "Suivant",
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
