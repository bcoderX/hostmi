import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/ui/pages/add_house2.dart';
import 'package:hostmi/ui/widgets/labeled_dropdown.dart';
import 'package:hostmi/ui/widgets/labeled_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddHouse1 extends StatefulWidget {
  const AddHouse1({Key? key}) : super(key: key);

  @override
  State<AddHouse1> createState() => _AddHouse1State();
}

class _AddHouse1State extends State<AddHouse1> {
  final SizedBox _spacer = SizedBox(
    height: 25.0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: AppColor.grey,
            statusBarIconBrightness: Brightness.dark),
        title: Text(AppLocalizations.of(context)!.addHouse),
        actions: const [],
      ),
      body: Scrollbar(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    AppLocalizations.of(context)!.baseInformation,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 5.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: AppColor.primary,
                    ),
                    child:  Center(
                      child: Text(
                        "${AppLocalizations.of(context)!.step} 1/3",
                        style: TextStyle(
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _spacer,
              LabeledDropdownField(
                value: AppLocalizations.of(context)!.singleHouse,
                label: AppLocalizations.of(context)!.propertyType,
                items:  [
                  DropdownMenuItem<String>(
                      value: AppLocalizations.of(context)!.singleHouse, child: Text(AppLocalizations.of(context)!.singleHouse)),
                  DropdownMenuItem<String>(
                      value: AppLocalizations.of(context)!.commonHouse, child: Text(AppLocalizations.of(context)!.commonHouse)),
                ],
                onChanged: (String? value) {},
              ),
              _spacer,
               LabeledField(
                label: AppLocalizations.of(context)!.price,
                isRequired: true,
                placeholder: "15000",
              ),
              _spacer,
               LabeledField(
                isRequired: true,
                label: AppLocalizations.of(context)!.numberOfBedRooms,
                placeholder: "1",
              ),
              _spacer,
               LabeledField(
                label: AppLocalizations.of(context)!.numberOfBathrooms,
                isRequired: true,
                placeholder: "1",
              ),
              _spacer,
               LabeledField(
                label: AppLocalizations.of(context)!.town,
                isRequired: true,
                placeholder: "Koudougou",
              ),
              _spacer,
               LabeledField(
                label: AppLocalizations.of(context)!.quarter,
                isRequired: true,
                placeholder: "Bourkina",
              ),
              _spacer,
               LabeledField(
                label: AppLocalizations.of(context)!.sector,
                isRequired: true,
                placeholder: "9",
              ),
              _spacer,
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.tenantType),
                ],
              ),
              _spacer,
              LabeledDropdownField(
                label: AppLocalizations.of(context)!.occupation,
                value: "any",
                items:  [
                  DropdownMenuItem<String>(
                      value: "any", child: Text(AppLocalizations.of(context)!.any)),
                  DropdownMenuItem<String>(
                      value: "officials", child: Text(AppLocalizations.of(context)!.officials)),
                  DropdownMenuItem<String>(
                      value: "intern", child: Text(AppLocalizations.of(context)!.interns)),
                  DropdownMenuItem<String>(
                      value: "students", child: Text(AppLocalizations.of(context)!.students)),
                  DropdownMenuItem<String>(
                      value: "buisnessman", child: Text(AppLocalizations.of(context)!.businessOwners)),
                ],
                onChanged: (String? value) {},
              ),
              _spacer,
              LabeledDropdownField(
                label: AppLocalizations.of(context)!.sex,
                value: "any",
                items:  [
                  DropdownMenuItem<String>(
                      value: "any", child: Text(AppLocalizations.of(context)!.any)),
                  DropdownMenuItem<String>(
                      value: "woman", child: Text(AppLocalizations.of(context)!.female)),
                  DropdownMenuItem<String>(
                      value: "man", child: Text(AppLocalizations.of(context)!.male)),
                ],
                onChanged: (String? value) {},
              ),
              _spacer,
              LabeledDropdownField(
                label: AppLocalizations.of(context)!.maritalStatus,
                value: "any",
                items:  [
                  DropdownMenuItem<String>(
                      value: "any", child: Text(AppLocalizations.of(context)!.any)),
                  DropdownMenuItem<String>(
                      value: "single", child: Text(AppLocalizations.of(context)!.single)),
                  DropdownMenuItem<String>(
                      value: ",married", child: Text(AppLocalizations.of(context)!.couple)),
                ],
                onChanged: (String? value) {},
              ),
              _spacer,
              MaterialButton(
                  color: AppColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const AddHouse2();
                        },
                      ),
                    );
                  },
                  child:  Text(
                    AppLocalizations.of(context)!.addPicturesNow,
                    style: TextStyle(color: AppColor.grey),
                  ))
            ],
          ),
        ),
      )),
    );
  }
}
