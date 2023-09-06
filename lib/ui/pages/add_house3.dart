import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/ui/pages/gears_loading_page.dart';
import 'package:hostmi/ui/pages/landlord_page.dart';
import 'package:hostmi/ui/pages/under_verification_page.dart';
import 'package:hostmi/ui/widgets/labeled_dropdown.dart';
import 'package:hostmi/ui/widgets/labeled_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddHouse3 extends StatefulWidget {
  const AddHouse3({Key? key}) : super(key: key);

  @override
  State<AddHouse3> createState() => _AddHouse3State();
}

class _AddHouse3State extends State<AddHouse3> {
  final SizedBox _spacer = new SizedBox(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    AppLocalizations.of(context)!.features,
                    style:
                        const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
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
                        "${AppLocalizations.of(context)!.step} 3/3",
                        style: const TextStyle(
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _spacer,
              Text(AppLocalizations.of(context)!.houseFeatures),
              const SizedBox(
                height: 10.0,
              ),
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 4.0,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                children: [
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.water),
                    value: true,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.garden),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.power),
                    value: true,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.store),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.internalKitchen),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.internalBathroom),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.pool),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.parking),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.paved),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.bar),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.trees),
                    value: false,
                  ),
                  CheckboxListTile(
                    activeColor: Colors.indigo,
                    onChanged: (bool? value) {},
                    title: Text(AppLocalizations.of(context)!.flowers),
                    value: false,
                  ),
                ],
              ),
              _spacer,
              Container(width: double.infinity, height: 1, color: AppColor.placeholderGrey,),
              _spacer,
               LabeledField(
                label: AppLocalizations.of(context)!.description,
                placeholder: AppLocalizations.of(context)!.houseDescHint,
                maxLines: 4,
              ),
              _spacer,
               LabeledField(
                label: AppLocalizations.of(context)!.accessConditions,
                placeholder: AppLocalizations.of(context)!.accessConditionsHint,
                maxLines: 4,
              ),
              _spacer,
               LabeledField(
                label: AppLocalizations.of(context)!.nearbyPlaces,
                placeholder: AppLocalizations.of(context)!.nearbyPlacesHint,
                maxLines: 4,
              ),
              /*_spacer,
              const LabeledField(
                label: "Contrat de bail",
                placeholder: "Sélectionner un fichier",
              ),*/
              _spacer,
              MaterialButton(
                  color: AppColor.primary,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return GearsLoadingPage(
                              page: const UnderVerificationPage(page: LandlordPage()
                              ), operationTitle: AppLocalizations.of(context)!.savingHouse,
                          );
                        },
                      ),
                    );
                  },
                  child:  Text(
                    AppLocalizations.of(context)!.publishNow,
                    style: const TextStyle(color: AppColor.grey),
                  ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
