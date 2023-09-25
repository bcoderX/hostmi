import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/ui/screens/gears_loading_page.dart';
import 'package:hostmi/ui/screens/landlord_screen.dart';
import 'package:hostmi/ui/screens/success_screen.dart';
import 'package:hostmi/ui/widgets/labeled_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);
  static const String path = "createPage";
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final SizedBox _spacer = const SizedBox(height: 25.0);
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController cities = TextEditingController();
  TextEditingController references = TextEditingController();
  TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Text(
          AppLocalizations.of(context)!.createPage,
          style: const TextStyle(
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
                      ])),
                ],
              ),
              _spacer,
              LabeledField(
                controller: name,
                label: AppLocalizations.of(context)!.pageName,
                isRequired: true,
                placeholder:
                    "${AppLocalizations.of(context)!.pageNameHint}. ex: Hostmi",
              ),
              _spacer,
              LabeledField(
                controller: phoneNumber,
                label: AppLocalizations.of(context)!.phoneNumber,
                isRequired: true,
                placeholder:
                    "${AppLocalizations.of(context)!.typePhoneNumber}. ex: +22664260325",
              ),
              _spacer,
              LabeledField(
                controller: email,
                label: "Email",
                isRequired: true,
                placeholder: "example@email.com",
              ),
              _spacer,
              LabeledField(
                controller: address,
                label: "Address",
                isRequired: true,
                placeholder: "Secteur 9, Koudougou, Burkina Faso",
              ),
              _spacer,
              LabeledField(
                controller: cities,
                label: AppLocalizations.of(context)!.coveredTowns,
                isRequired: true,
                placeholder: AppLocalizations.of(context)!.coveredTownsHint,
              ),
              _spacer,
              LabeledField(
                label: "IFU/RCCM(${AppLocalizations.of(context)!.optional})",
                placeholder: "Les références légales de votre entreprises",
              ),
              _spacer,
              LabeledField(
                controller: description,
                label: AppLocalizations.of(context)!.description,
                isRequired: true,
                placeholder: AppLocalizations.of(context)!.pageDescHint,
                maxLines: 4,
              ),
              _spacer,
              MaterialButton(
                  color: AppColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  minWidth: double.infinity,
                  onPressed: () {
                    // context.read<AuthProvider>().createPage(
                    //       user: "VXNlck5vZGU6MTA=",
                    //       name: name.text,
                    //       phoneNumber: phoneNumber.text,
                    //       email: email.text,
                    //       cities: cities.text,
                    //       references: references.text,
                    //       description: description.text,
                    //       address: address.text,
                    //     );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return GearsLoadingPage(
                            page: const SuccessPage(
                              continueToPage: LandlordPage(),
                            ),
                            operationTitle:
                                AppLocalizations.of(context)!.creatingPage,
                          );
                        },
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.createYourPage,
                    style: const TextStyle(
                      color: AppColor.grey,
                    ),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
