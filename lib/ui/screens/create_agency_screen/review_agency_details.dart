import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/models/agency_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/agencies/create_agency.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/screens/gears_loading_page.dart';
import 'package:hostmi/ui/widgets/labeled_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../widgets/labeled_dropdown.dart';

class ReviewAgencyDetails extends StatefulWidget {
  const ReviewAgencyDetails({Key? key}) : super(key: key);

  @override
  State<ReviewAgencyDetails> createState() => _ReviewAgencyDetailsState();
}

class _ReviewAgencyDetailsState extends State<ReviewAgencyDetails> {
  final GlobalKey<FormState> _formState = GlobalKey();
  bool _isCreating = false;
  final SizedBox _spacer = const SizedBox(height: 25.0);

  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _citiesController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  bool _isCreated = false;

  @override
  Widget build(BuildContext context) {
    _nameController.text = context.read<HostmiProvider>().agencyName;
    _descriptionController.text =
        context.read<HostmiProvider>().agencyDescription;
    _phoneNumberController.text = context.read<HostmiProvider>().agencyPhone;
    _emailController.text = context.read<HostmiProvider>().agencyEmail;
    _addressController.text = context.read<HostmiProvider>().agencyAdress;
    _citiesController.text = context.read<HostmiProvider>().agencyTowns;
    return _isCreating
        ? GearsLoadingPage(
            operationTitle: AppLocalizations.of(context)!.creatingPage,
          )
        : Scaffold(
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Vérifier et confirmer",
                            style: TextStyle(
                              color: AppColor.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      _spacer,
                      LabeledField(
                        controller: _nameController,
                        label: "Nom de l'agence",
                        isRequired: true,
                        placeholder:
                            "${AppLocalizations.of(context)!.pageNameHint}. ex: Hostmi",
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
                              child: Text(country["fr"].toString()));
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
                      ),
                      _spacer,
                      LabeledField(
                        controller: _phoneNumberController,
                        label: AppLocalizations.of(context)!.phoneNumber,
                        isRequired: true,
                        placeholder: "+22664260325",
                      ),
                      _spacer,
                      LabeledField(
                        controller: _emailController,
                        label: "Email",
                        isRequired: true,
                        placeholder: "example@email.com",
                      ),
                      _spacer,
                      LabeledField(
                        controller: _addressController,
                        label: "Address",
                        isRequired: true,
                        placeholder: "Secteur 9, Koudougou, Burkina Faso",
                      ),
                      _spacer,
                      LabeledField(
                        controller: _citiesController,
                        label: AppLocalizations.of(context)!.coveredTowns,
                        isRequired: true,
                        placeholder:
                            AppLocalizations.of(context)!.coveredTownsHint,
                      ),
                      _spacer,
                      MaterialButton(
                          color: _isCreating
                              ? AppColor.primary.withOpacity(.5)
                              : AppColor.primary,
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          minWidth: double.infinity,
                          onPressed: _isCreating
                              ? null
                              : () {
                                  _createNewAgency(context);
                                },
                          child: const Text(
                            "Créer l'agence",
                            style: TextStyle(
                              color: AppColor.grey,
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            )),
          );
  }

  Future<void> _createNewAgency(BuildContext context) async {
    // context.go(keyCreateAgencyAddPicturesFullRoute);
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
    context.read<HostmiProvider>().setAgencyPhone(_phoneNumberController.text);
    context.read<HostmiProvider>().setAgencyEmail(_emailController.text);
    context.read<HostmiProvider>().setAgencyAddress(_addressController.text);
    context.read<HostmiProvider>().setAgencyPlace(_citiesController.text);
    setState(() {
      _isCreating = true;
    });
    final AgencyModel agency = AgencyModel(
        countryId: int.parse(context.read<HostmiProvider>().agencyCountryId),
        createdBy: supabase.auth.currentUser!.id,
        name: context.read<HostmiProvider>().agencyName,
        description: context.read<HostmiProvider>().agencyDescription,
        phoneNumber: context.read<HostmiProvider>().agencyPhone,
        cities: context.read<HostmiProvider>().agencyTowns,
        address: context.read<HostmiProvider>().agencyAdress,
        email: context.read<HostmiProvider>().agencyEmail);
    final result = await createAgency(agency);

    if (result.isNotEmpty) {
      _isCreating = false;
      if (result[0]["name"] == agency.name) {
        setState(() {
          _isCreated = true;
          _isCreating = false;
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Reussi"),
                content: const Text("La creation a reussi"),
                actions: [
                  TextButton(
                      onPressed: () {
                        context.go(keyCreateAgencyAddPicturesFullRoute);
                        Navigator.of(context).pop();
                      },
                      child: const Text("Continuer"))
                ],
              );
            },
          );
        });
      }
    } else {
      setState(() {
        _isCreating = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Erreur"),
            content: const Text("Une erreur s'est produite."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ok"))
            ],
          );
        },
      );
    }
  }
}
