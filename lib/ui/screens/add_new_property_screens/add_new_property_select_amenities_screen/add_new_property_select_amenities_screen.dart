import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/api/models/job.dart';
import 'package:hostmi/api/models/marital_status.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_property_pictures/add_property_pictures.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_drop_down.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

import '../../../../api/models/gender.dart';
import '../add_new_property_select_amenities_screen/widgets/options_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddNewPropertySelectAmenitiesScreen extends StatefulWidget {
  const AddNewPropertySelectAmenitiesScreen({super.key});

  @override
  State<AddNewPropertySelectAmenitiesScreen> createState() =>
      _AddNewPropertySelectAmenitiesScreenState();
}

class _AddNewPropertySelectAmenitiesScreenState
    extends State<AddNewPropertySelectAmenitiesScreen> {
  final SizedBox _spacer = const SizedBox(height: 25);
  List<int> selectedFeatures = [];
  Gender selectedGender = const Gender(
    id: 3,
    en: "Any",
    fr: "N'importe lequel",
  );
  Job selectedJob = const Job(id: 4, en: "Any", fr: "N'importe lequel");
  MaritalStatus selectedMaritalStatus = const MaritalStatus(
    id: 3,
    en: "Any",
    fr: "N'importe lequel",
  );

  @override
  void initState() {
    selectedFeatures =
        context.read<HostmiProvider>().houseForm.features as List<int>? ?? [];
    selectedGender = context.read<HostmiProvider>().houseForm.gender!;
    selectedJob = context.read<HostmiProvider>().houseForm.occupation!;
    selectedMaritalStatus =
        context.read<HostmiProvider>().houseForm.maritalStatus!;
    descriptionController.text =
        context.read<HostmiProvider>().houseForm.description ?? "";
    super.initState();
  }

  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HostmiProvider>().getHouseFeatures();
      context.read<HostmiProvider>().getGenders();
      context.read<HostmiProvider>().getJobs();
      context.read<HostmiProvider>().getMaritalStatus();
    });
    return Scaffold(
      backgroundColor: ColorConstant.gray50,
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //     statusBarColor: AppColor.grey,
        //     statusBarIconBrightness: Brightness.dark),
        title: Text(AppLocalizations.of(context)!.addHouse),
        actions: const [],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: getPadding(top: 6, bottom: 6),
                          child: Text("Caractéristiques et clients cibles",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtManropeSemiBold14Gray900)),
                      CustomButton(
                          height: getVerticalSize(33),
                          width: getHorizontalSize(79),
                          text: "03 / 04",
                          fontStyle:
                              ButtonFontStyle.ManropeSemiBold14WhiteA700_1)
                    ]),
                Container(
                    height: getVerticalSize(6),
                    width: getHorizontalSize(327),
                    margin: getMargin(top: 16),
                    child: Stack(alignment: Alignment.center, children: [
                      Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                              width: getHorizontalSize(327),
                              child: Divider(
                                  height: getVerticalSize(6),
                                  thickness: getVerticalSize(6),
                                  color: ColorConstant.blueGray50))),
                      Align(
                          alignment: Alignment.center,
                          child: Container(
                              height: getVerticalSize(6),
                              width: getHorizontalSize(327),
                              decoration: BoxDecoration(
                                  color: ColorConstant.blueGray50,
                                  borderRadius: BorderRadius.circular(
                                      getHorizontalSize(3))),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(getHorizontalSize(3)),
                                child: LinearProgressIndicator(
                                    value: 0.75,
                                    backgroundColor: ColorConstant.blueGray50,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        ColorConstant.brown500)),
                              )))
                    ])),
                Padding(
                    padding: getPadding(top: 24),
                    child: Text(
                        "Choisir les caractéristiques (${selectedFeatures.length})",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeBold18
                            .copyWith(letterSpacing: getHorizontalSize(0.2)))),
                Padding(
                  padding: getPadding(top: 15, bottom: 5),
                  child: Wrap(
                    runSpacing: getVerticalSize(5),
                    spacing: getHorizontalSize(5),
                    children: context
                        .watch<HostmiProvider>()
                        .houseFeaturesList
                        .map((feature) => OptionsItemWidget(
                              amenity: feature,
                              selected: selectedFeatures,
                              onPressed: () => onSelected(feature["id"]),
                            ))
                        .toList(),
                  ),
                ),
                Padding(
                    padding: getPadding(top: 24),
                    child: Text("Clients cibles",
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtManropeBold18
                            .copyWith(letterSpacing: getHorizontalSize(0.2)))),
                _spacer,
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Sexe",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: AppColor.listItemGrey,
                    ),
                  ),
                ),
                CustomDropDown<Gender>(
                    value: context.read<HostmiProvider>().houseForm.gender,
                    //focusNode: FocusNode(),
                    icon: Container(
                        margin: getMargin(left: 30, right: 16),
                        child: CustomImageView(
                            svgPath: ImageConstant.imgArrowdownGray900)),
                    hintText: "Choisir le sexe",
                    margin: getMargin(top: 12),
                    variant: DropDownVariant.FillBluegray50,
                    fontStyle: DropDownFontStyle.ManropeMedium14Bluegray500,
                    items: context
                        .watch<HostmiProvider>()
                        .gendersList
                        .map((gender) {
                      return DropdownMenuItem<Gender>(
                          value: Gender.fromMap(data: gender),
                          child: Text(
                            gender["fr"].toString(),
                            overflow: TextOverflow.ellipsis,
                          ));
                    }).toList(),
                    onChanged: (value) {
                      selectedGender = value;
                    }),
                _spacer,
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Occupations",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: AppColor.listItemGrey,
                    ),
                  ),
                ),
                CustomDropDown<Job>(
                    value: context.read<HostmiProvider>().houseForm.occupation,
                    //focusNode: FocusNode(),
                    icon: Container(
                        margin: getMargin(left: 30, right: 16),
                        child: CustomImageView(
                            svgPath: ImageConstant.imgArrowdownGray900)),
                    hintText: "Choisir un travail",
                    margin: getMargin(top: 12),
                    variant: DropDownVariant.FillBluegray50,
                    fontStyle: DropDownFontStyle.ManropeMedium14Bluegray500,
                    items: context.watch<HostmiProvider>().jobsList.map((job) {
                      return DropdownMenuItem<Job>(
                          value: Job.fromMap(data: job),
                          child: Text(
                            job["fr"].toString(),
                            overflow: TextOverflow.ellipsis,
                          ));
                    }).toList(),
                    onChanged: (value) {
                      selectedJob = value;
                    }),
                _spacer,
                const SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Situation matrimoniale",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: AppColor.listItemGrey,
                    ),
                  ),
                ),
                CustomDropDown<MaritalStatus>(
                    value:
                        context.read<HostmiProvider>().houseForm.maritalStatus,
                    //focusNode: FocusNode(),
                    icon: Container(
                        margin: getMargin(left: 30, right: 16),
                        child: CustomImageView(
                            svgPath: ImageConstant.imgArrowdownGray900)),
                    hintText: "Choisir la situation matrimoniale",
                    margin: getMargin(top: 12),
                    variant: DropDownVariant.FillBluegray50,
                    fontStyle: DropDownFontStyle.ManropeMedium14Bluegray500,
                    items: context
                        .watch<HostmiProvider>()
                        .maritalStatusList
                        .map((status) {
                      return DropdownMenuItem<MaritalStatus>(
                          value: MaritalStatus.fromMap(data: status),
                          child: Text(
                            status["fr"].toString(),
                            overflow: TextOverflow.ellipsis,
                          ));
                    }).toList(),
                    onChanged: (value) {
                      selectedMaritalStatus = value;
                    }),
                _spacer,
                Padding(
                  padding: getPadding(top: 24),
                  child: Text(
                    "Description (Facultatif)",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtManropeBold18.copyWith(
                      letterSpacing: getHorizontalSize(0.2),
                    ),
                  ),
                ),
                CustomTextFormField(
                  //focusNode: FocusNode(),
                  controller: descriptionController,
                  hintText: "Faites une petite description de la maison",
                  margin: getMargin(top: 12),
                  textInputType: TextInputType.text,
                  maxLines: 6,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DefaultAppButton(
                    text: "Suivant",
                    onPressed: () {
                      onTapNext(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onTapNext(BuildContext context) {
    context.read<HostmiProvider>().houseForm.features = selectedFeatures;
    context.read<HostmiProvider>().houseForm.gender = selectedGender;
    context.read<HostmiProvider>().houseForm.occupation = selectedJob;
    context.read<HostmiProvider>().houseForm.maritalStatus =
        selectedMaritalStatus;
    context.read<HostmiProvider>().houseForm.description =
        descriptionController.text.trim();
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const AddPropertyPictures()));
    //Navigator.pushNamed(context, AppRoutes.addNewPropertyDetailsScreen);
  }

  onTapArrowleft12(BuildContext context) {
    Navigator.pop(context);
  }

  onSelected(int index) {
    setState(() {
      if (selectedFeatures.contains(index)) {
        selectedFeatures.remove(index);
      } else {
        selectedFeatures.add(index);
      }
    });
  }
}
