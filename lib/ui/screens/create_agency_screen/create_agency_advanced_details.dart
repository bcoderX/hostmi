import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/widgets/labeled_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CreateAgencyAdvancedDetails extends StatelessWidget {
  CreateAgencyAdvancedDetails({Key? key}) : super(key: key);
  final _formState = GlobalKey<FormState>();
  final SizedBox _spacer = const SizedBox(height: 25.0);
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _citiesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _phoneNumberController.text = context.read<HostmiProvider>().agencyPhone;
    _emailController.text = context.read<HostmiProvider>().agencyEmail;
    _addressController.text = context.read<HostmiProvider>().agencyAdress;
    _citiesController.text = context.read<HostmiProvider>().agencyTowns;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //   statusBarIconBrightness: Brightness.dark,
        // ),
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
              children: [
                _spacer,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Dites-nous comment contacter ${context.read<HostmiProvider>().agencyName}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColor.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                _spacer,
                LabeledField(
                  controller: _phoneNumberController,
                  label: AppLocalizations.of(context)!.phoneNumber,
                  isRequired: true,
                  keyboardType: TextInputType.phone,
                  placeholder: "+22664260325",
                  errorText: "Veuillez saisir votre numéro",
                ),
                _spacer,
                LabeledField(
                  controller: _emailController,
                  label: "Email",
                  isRequired: true,
                  keyboardType: TextInputType.emailAddress,
                  placeholder: "example@email.com",
                  errorText: "Veuillez saisir votre Email",
                ),
                _spacer,
                LabeledField(
                  controller: _addressController,
                  label: "Address",
                  isRequired: true,
                  keyboardType: TextInputType.streetAddress,
                  placeholder: "Secteur 9, Koudougou, Burkina Faso",
                  errorText: "Veuillez saisir votre addressw",
                ),
                _spacer,
                LabeledField(
                  controller: _citiesController,
                  label: AppLocalizations.of(context)!.coveredTowns,
                  isRequired: true,
                  placeholder: AppLocalizations.of(context)!.coveredTownsHint,
                  errorText: "Veuillez saisir les villes où vous êtes",
                ),
                _spacer,
                MaterialButton(
                  color: AppColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  minWidth: double.infinity,
                  onPressed: () {
                    if (_formState.currentState!.validate()) {
                      context
                          .read<HostmiProvider>()
                          .setAgencyPhone(_phoneNumberController.text);
                      context
                          .read<HostmiProvider>()
                          .setAgencyEmail(_emailController.text);
                      context
                          .read<HostmiProvider>()
                          .setAgencyAddress(_addressController.text);
                      context
                          .read<HostmiProvider>()
                          .setAgencyPlace(_citiesController.text);
                      context.go(keyReviewAgencyDetailsFullRoute);
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
                        "Vérifier et confirmer",
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
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
