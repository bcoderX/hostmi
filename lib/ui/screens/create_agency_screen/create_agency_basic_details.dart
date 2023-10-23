import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/widgets/labeled_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../widgets/labeled_dropdown.dart';

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
      context.read<HostmiProvider>().getCountries();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
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
              children: [
                _spacer,
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: AppColor.black),
                        children: [
                          const TextSpan(
                              text: "* ", style: TextStyle(color: Colors.red)),
                          TextSpan(
                              text:
                                  " ${AppLocalizations.of(context)!.requiredFieldsWithStar}."),
                        ],
                      ),
                    ),
                  ],
                ),
                _spacer,
                LabeledField(
                  controller: _nameController,
                  label: "Nom de l'agence",
                  isRequired: true,
                  placeholder:
                      "${AppLocalizations.of(context)!.pageNameHint}. ex: Hostmi",
                  errorText: "Veullez saisir le nom de votre agence",
                ),
                _spacer,
                LabeledDropdownField(
                  label: "Pays",
                  value: context.read<HostmiProvider>().agencyCountryId,
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
                _spacer,
                LabeledField(
                  controller: _descriptionController,
                  label: AppLocalizations.of(context)!.description,
                  isRequired: true,
                  placeholder: AppLocalizations.of(context)!.pageDescHint,
                  maxLines: 4,
                  errorText: "Saisir une petite description de votre agence",
                ),
                _spacer,
                Material(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(5.0),
                  child: MaterialButton(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    minWidth: double.infinity,
                    onPressed: () {
                      if (_formState.currentState!.validate()) {
                        context
                            .read<HostmiProvider>()
                            .setAgencyName(_nameController.text);
                        context
                            .read<HostmiProvider>()
                            .setAgencyDescription(_descriptionController.text);
                        context.go(keyCreateAgencyAdvancedDetailsFullRoute);
                      }
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (BuildContext context) {
                      //       return GearsLoadingPage(
                      //         page: const SuccessPage(
                      //           continueToPage: LandlordPage(),
                      //         ),
                      //         operationTitle:
                      //             AppLocalizations.of(context)!.creatingPage,
                      //       );
                      //     },
                      //   ),
                      // );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Suivant",
                          style: TextStyle(
                            color: AppColor.grey,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right_outlined,
                          size: 20.0,
                          color: Colors.white,
                        )
                      ],
                    ),
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
