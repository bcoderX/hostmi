import 'package:flutter/scheduler.dart';
import 'package:hostmi/api/models/country_model.dart';
import 'package:hostmi/api/models/currency.dart';
import 'package:hostmi/api/models/gender.dart';
import 'package:hostmi/api/models/house_category.dart';
import 'package:hostmi/api/models/house_features.dart';
import 'package:hostmi/api/models/house_type.dart';
import 'package:hostmi/api/models/job.dart';
import 'package:hostmi/api/models/marital_status.dart';
import 'package:hostmi/api/models/price_type.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/utils/check_connection_and_do.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_new_property_select_amenities_screen/widgets/options_item_widget.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_drop_down.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';
import '../filter_screen/widgets/listbeds_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/custom_button.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key, this.onValidate}) : super(key: key);
  final void Function()? onValidate;
  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final _spacer = const SizedBox(height: 20);

  late List<HouseType> selectedHouseType;
  late List<HouseCategory> selectedHouseCategory;
  late List<HouseFeatures> selectedFeatures;
  late List<Gender> selectedGenders;
  late List<Job> selectedJobs;
  late List<MaritalStatus> selectedMaritalStatus;

  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late final TextEditingController _cityController;
  late final TextEditingController _quarterController;
  late final TextEditingController _sectorController;

  late Country selectedCountry;
  late PriceType selectedPriceType;
  late Currency selectedCurrency;
  late int numberOfBeds;
  late int numberOfBathRooms;

  @override
  void initState() {
    _minPriceController = TextEditingController();
    _maxPriceController = TextEditingController();
    _cityController = TextEditingController();
    _quarterController = TextEditingController();
    _sectorController = TextEditingController();
    _minPriceController.text =
        context.read<HostmiProvider>().filterForm.minPrice.toString();
    _maxPriceController.text =
        context.read<HostmiProvider>().filterForm.maxPrice.toString();
    _cityController.text = context.read<HostmiProvider>().filterForm.cities;
    // .map((e) => e.replaceAll(r"%", ""))
    // .join(", ");

    _quarterController.text = context
        .read<HostmiProvider>()
        .filterForm
        .quarters
        .map((e) => e.replaceAll(r"%", ""))
        .join(", ");
    _sectorController.text = context
        .read<HostmiProvider>()
        .filterForm
        .sectors
        .map((e) => e)
        .join(", ");
    numberOfBeds = context.read<HostmiProvider>().filterForm.beds;
    numberOfBathRooms = context.read<HostmiProvider>().filterForm.bathrooms;
    selectedCurrency = context.read<HostmiProvider>().filterForm.currency;
    selectedPriceType = context.read<HostmiProvider>().filterForm.priceType;
    selectedCountry = context.read<HostmiProvider>().filterForm.country;
    selectedHouseType = context.read<HostmiProvider>().filterForm.types;
    selectedHouseCategory =
        context.read<HostmiProvider>().filterForm.categories;
    selectedFeatures = context.read<HostmiProvider>().filterForm.features;
    selectedGenders = context.read<HostmiProvider>().filterForm.genders;
    selectedJobs = context.read<HostmiProvider>().filterForm.occupations;
    selectedMaritalStatus =
        context.read<HostmiProvider>().filterForm.maritalStatus;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      checkConnectionAndDo(() {
        context.read<HostmiProvider>().getPriceTypes();
        context.read<HostmiProvider>().getHouseFeatures();
        context.read<HostmiProvider>().getHouseTypes();
        context.read<HostmiProvider>().getHouseCategories();
        context.read<HostmiProvider>().getCurrencies();
        context.read<HostmiProvider>().getGenders();
        context.read<HostmiProvider>().getJobs();
        context.read<HostmiProvider>().getMaritalStatus();
        context.read<HostmiProvider>().getCountries();
      });
    });
    return Scaffold(
      backgroundColor: ColorConstant.gray50,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        title: const Text(
          "Filtrer",
          style: TextStyle(color: AppColor.black),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              _onApplyFilters(context);
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.check,
              color: AppColor.primary,
              size: 20,
            ),
            label: const Text("Appliquer"),
          )
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Affiner vos rechercherches avec des filtres avancés.",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: AppColor.listItemGrey,
                    ),
                  ),
                ),
                SizedBox(
                  width: double.maxFinite,
                  child: Container(
                    margin: getMargin(top: 16),
                    decoration: AppDecoration.fillGray50,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "Prix",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                            Expanded(
                                child: CustomDropDown<PriceType>(
                              value: context
                                  .read<HostmiProvider>()
                                  .filterForm
                                  .priceType,
                              variant: DropDownVariant.FillBluegray50,
                              fontStyle:
                                  DropDownFontStyle.ManropeMedium14Bluegray500,
                              items: context
                                  .watch<HostmiProvider>()
                                  .priceTypesList
                                  .map((priceType) {
                                return DropdownMenuItem<PriceType>(
                                    value: PriceType.fromMap(data: priceType),
                                    child: Text(
                                      priceType["fr"].toString(),
                                      overflow: TextOverflow.ellipsis,
                                    ));
                              }).toList(),
                              onChanged: (value) {
                                selectedPriceType = value;
                              },
                            ))
                          ],
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: getPadding(top: 6),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextFormField(
                                      labelText: "min",
                                      controller: _minPriceController,
                                      hintText: "min",
                                      margin: getMargin(top: 13),
                                      textInputType: TextInputType.text,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: CustomTextFormField(
                                      labelText: "max",
                                      controller: _maxPriceController,
                                      hintText: "max",
                                      margin: getMargin(top: 13),
                                      textInputType: TextInputType.text,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Padding(
                          padding: getPadding(top: 25),
                          child: const SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Monnaie utilisée",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: AppColor.listItemGrey),
                            ),
                          ),
                        ),
                        Padding(
                          padding: getPadding(top: 7),
                          child: CustomDropDown<Currency>(
                              value: context
                                  .read<HostmiProvider>()
                                  .filterForm
                                  .currency,
                              //focusNode: FocusNode(),
                              icon: Container(
                                  margin: getMargin(left: 30, right: 16),
                                  child: CustomImageView(
                                      svgPath:
                                          ImageConstant.imgArrowdownGray900)),
                              margin: getMargin(top: 12),
                              variant: DropDownVariant.FillBluegray50,
                              fontStyle:
                                  DropDownFontStyle.ManropeMedium14Bluegray500,
                              items: context
                                  .watch<HostmiProvider>()
                                  .currenciesList
                                  .map((currency) {
                                return DropdownMenuItem<Currency>(
                                    value: Currency.fromMap(data: currency),
                                    child: Text(
                                      "${currency["currency"] + ' - ' + currency["en"]}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ));
                              }).toList(),
                              onChanged: (value) {
                                selectedCurrency = value;
                              }),
                        ),
                        _spacer,
                        Container(
                          width: double.infinity,
                          height: 15,
                          color: AppColor.grey,
                        ),
                        Padding(
                            padding: getPadding(top: 25),
                            child: Text("Pièces",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeExtraBold18Blue500
                                    .copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.2)))),
                        Padding(
                          padding: getPadding(top: 25),
                          child: ListbedsItemWidget(
                              label: 'Nombre de chambres',
                              value: numberOfBeds,
                              onDecrease: () {
                                setState(() {
                                  numberOfBeds =
                                      numberOfBeds > 0 ? numberOfBeds - 1 : -1;
                                });
                              },
                              onIncrease: () {
                                setState(() {
                                  numberOfBeds = numberOfBeds + 1;
                                });
                              }),
                        ),
                        Padding(
                          padding: getPadding(top: 7),
                          child: ListbedsItemWidget(
                              label: 'Nombre de douches',
                              value: numberOfBathRooms,
                              onDecrease: () {
                                setState(() {
                                  numberOfBathRooms = numberOfBathRooms > 0
                                      ? numberOfBathRooms - 1
                                      : -1;
                                });
                              },
                              onIncrease: () {
                                setState(() {
                                  numberOfBathRooms = numberOfBathRooms + 1;
                                });
                              }),
                        ),
                        _spacer,
                        Container(
                          width: double.infinity,
                          height: 15,
                          color: AppColor.grey,
                        ),
                        Padding(
                            padding: getPadding(top: 25),
                            child: Text("Lieux",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeExtraBold18Blue500
                                    .copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.2)))),
                        Padding(
                            padding: getPadding(top: 5),
                            child: Text(
                                "Vous pouvez choisir plusieurs en séparant avec des virgules",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeMedium14Gray900)),
                        Padding(
                            padding: getPadding(top: 17),
                            child: Text("Pays",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeSemiBold14Gray900)),
                        CustomDropDown<Country>(
                            value: context
                                .read<HostmiProvider>()
                                .filterForm
                                .country,
                            //focusNode: FocusNode(),
                            icon: Container(
                                margin: getMargin(left: 30, right: 16),
                                child: CustomImageView(
                                    svgPath:
                                        ImageConstant.imgArrowdownGray900)),
                            margin: getMargin(top: 12),
                            variant: DropDownVariant.FillBluegray50,
                            fontStyle:
                                DropDownFontStyle.ManropeMedium14Bluegray500,
                            items: context
                                .watch<HostmiProvider>()
                                .countriesList
                                .map((country) {
                              return DropdownMenuItem<Country>(
                                  value: Country.fromMap(country),
                                  child: Text(
                                    country["fr"].toString(),
                                    overflow: TextOverflow.ellipsis,
                                  ));
                            }).toList(),
                            onChanged: (value) {
                              selectedCountry = value;
                            }),
                        Padding(
                            padding: getPadding(top: 17),
                            child: Text("Villes",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeSemiBold14Gray900)),
                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: getPadding(top: 6),
                              child: CustomTextFormField(
                                controller: _cityController,
                                hintText: "Ex : Abidjan, Ouagadougou, etc...",
                                margin: getMargin(top: 13),
                                textInputType: TextInputType.text,
                              ),
                            )),
                        Padding(
                            padding: getPadding(top: 17),
                            child: Text("Quartiers",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeSemiBold14Gray900)),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: getPadding(top: 6),
                            child: CustomTextFormField(
                              controller: _quarterController,
                              hintText: "Ex : Tampouy, Cocody, etc...",
                              margin: getMargin(top: 13),
                              textInputType: TextInputType.text,
                            ),
                          ),
                        ),
                        Padding(
                            padding: getPadding(top: 17),
                            child: Text("Secteurs",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeSemiBold14Gray900)),
                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: getPadding(top: 6),
                              child: CustomTextFormField(
                                controller: _sectorController,
                                hintText: "Ex : 1, 2, 12, etc...",
                                margin: getMargin(top: 13),
                                textInputType: TextInputType.text,
                              ),
                            )),
                        _spacer,
                        Container(
                          width: double.infinity,
                          height: 15,
                          color: AppColor.grey,
                        ),
                        Padding(
                            padding: getPadding(top: 27),
                            child: Text("Type de maison",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeExtraBold18Blue500
                                    .copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.2)))),
                        Padding(
                            padding: getPadding(top: 14),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              runSpacing: getVerticalSize(5),
                              spacing: getHorizontalSize(5),
                              children: context
                                  .watch<HostmiProvider>()
                                  .houseTypesList
                                  .map((houseType) => OptionsItemWidget(
                                        amenity: houseType,
                                        selected: selectedHouseType
                                            .map((e) => e.id)
                                            .toList(),
                                        onPressed: () => onSelectType(
                                            HouseType.fromMap(data: houseType)),
                                      ))
                                  .toList(),
                            )),
                        _spacer,
                        Container(
                          width: double.infinity,
                          height: 15,
                          color: AppColor.grey,
                        ),
                        Padding(
                            padding: getPadding(top: 27),
                            child: Text("Catégories de maison",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeExtraBold18Blue500
                                    .copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.2)))),
                        Padding(
                          padding: getPadding(top: 14),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: getVerticalSize(5),
                            spacing: getHorizontalSize(5),
                            children: context
                                .watch<HostmiProvider>()
                                .houseCategoriesList
                                .map((category) => OptionsItemWidget(
                                      amenity: category,
                                      selected: selectedHouseCategory
                                          .map((e) => e.id!)
                                          .toList(),
                                      onPressed: () => onSelectCategory(
                                          HouseCategory.fromMap(
                                              data: category)),
                                    ))
                                .toList(),
                          ),
                        ),
                        _spacer,
                        Container(
                          width: double.infinity,
                          height: 15,
                          color: AppColor.grey,
                        ),
                        Padding(
                          padding: getPadding(top: 25),
                          child: Row(
                            children: [
                              Text(
                                "Caractéristiques",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeExtraBold18Blue500
                                    .copyWith(
                                  letterSpacing: getHorizontalSize(0.2),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: getPadding(top: 16),
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              runSpacing: getVerticalSize(5),
                              spacing: getHorizontalSize(5),
                              children: context
                                  .watch<HostmiProvider>()
                                  .houseFeaturesList
                                  .map((feature) => OptionsItemWidget(
                                        amenity: feature,
                                        selected: selectedFeatures
                                            .map((e) => e.id!)
                                            .toList(),
                                        onPressed: () => onSelectFeature(
                                            HouseFeatures.fromMap(
                                                data: feature)),
                                      ))
                                  .toList(),
                            )),
                        _spacer,
                        Container(
                          width: double.infinity,
                          height: 15,
                          color: AppColor.grey,
                        ),
                        Padding(
                          padding: getPadding(top: 25),
                          child: Text(
                            "Profil du chercheur",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style:
                                AppStyle.txtManropeExtraBold18Blue500.copyWith(
                              letterSpacing: getHorizontalSize(0.2),
                            ),
                          ),
                        ),
                        Padding(
                            padding: getPadding(top: 5),
                            child: Text(
                                "Dites-nous un peu sur la personne qui va occuper la maison",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeMedium14Gray900)),
                        Padding(
                            padding: getPadding(top: 27),
                            child: Text("Sexe",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeExtraBold16Gray900
                                    .copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.2)))),
                        Padding(
                          padding: getPadding(top: 14),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: getVerticalSize(5),
                            spacing: getHorizontalSize(5),
                            children: context
                                .watch<HostmiProvider>()
                                .gendersList
                                .map((gender) => OptionsItemWidget(
                                      amenity: gender,
                                      selected: selectedGenders
                                          .map((e) => e.id!)
                                          .toList(),
                                      onPressed: () => onSelectGender(
                                          Gender.fromMap(data: gender)),
                                    ))
                                .toList(),
                          ),
                        ),
                        _spacer,
                        Container(
                          width: double.infinity,
                          height: 15,
                          color: AppColor.grey,
                        ),
                        Padding(
                            padding: getPadding(top: 27),
                            child: Text("Situation matrimoniale",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeExtraBold16Gray900
                                    .copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.2)))),
                        Padding(
                          padding: getPadding(top: 14),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: getVerticalSize(5),
                            spacing: getHorizontalSize(5),
                            children: context
                                .watch<HostmiProvider>()
                                .maritalStatusList
                                .map((status) => OptionsItemWidget(
                                      amenity: status,
                                      selected: selectedMaritalStatus
                                          .map((e) => e.id!)
                                          .toList(),
                                      onPressed: () => onSelectMaritalStatus(
                                          MaritalStatus.fromMap(data: status)),
                                    ))
                                .toList(),
                          ),
                        ),
                        _spacer,
                        Container(
                          width: double.infinity,
                          height: 15,
                          color: AppColor.grey,
                        ),
                        Padding(
                            padding: getPadding(top: 27),
                            child: Text("Occupations",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtManropeExtraBold16Gray900
                                    .copyWith(
                                        letterSpacing:
                                            getHorizontalSize(0.2)))),
                        Padding(
                          padding: getPadding(top: 14),
                          child: Wrap(
                            runSpacing: getVerticalSize(5),
                            spacing: getHorizontalSize(5),
                            alignment: WrapAlignment.spaceBetween,
                            children: context
                                .watch<HostmiProvider>()
                                .jobsList
                                .map((job) => OptionsItemWidget(
                                      amenity: job,
                                      selected: selectedJobs
                                          .map((e) => e.id!)
                                          .toList(),
                                      onPressed: () =>
                                          onSelectJob(Job.fromMap(data: job)),
                                    ))
                                .toList(),
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          margin: getMargin(top: 24),
                          padding: getPadding(all: 24),
                          decoration: AppDecoration.outlineBluegray1000f,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: CustomButton(
                                      onTap: () {
                                        context
                                            .read<HostmiProvider>()
                                            .resetFilters();
                                        widget.onValidate?.call();
                                        Navigator.of(context).pop();
                                      },
                                      height: getVerticalSize(56),
                                      text: "Rénitialiser",
                                      margin: getMargin(right: 7),
                                      variant: ButtonVariant.OutlineBlue500_2,
                                      shape: ButtonShape.RoundedBorder10,
                                      padding: ButtonPadding.PaddingAll16,
                                      fontStyle: ButtonFontStyle
                                          .ManropeBold16Blue500_1)),
                              Expanded(
                                  child: CustomButton(
                                      onTap: () {
                                        _onApplyFilters(context);
                                        Navigator.of(context).pop();
                                      },
                                      height: getVerticalSize(56),
                                      text: "Appliquer",
                                      margin: getMargin(left: 7),
                                      shape: ButtonShape.RoundedBorder10,
                                      padding: ButtonPadding.PaddingAll16,
                                      fontStyle: ButtonFontStyle
                                          .ManropeBold16WhiteA700_1))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onApplyFilters(BuildContext context) {
    if (selectedMaritalStatus.length == 1) {
      if (selectedMaritalStatus[0].id == 3) {
        context.read<HostmiProvider>().filterForm.maritalStatus =
            context.read<HostmiProvider>().maritalStatusList.map((e) {
          // print(e["id"]);
          return MaritalStatus.fromMap(data: e);
        }).toList();
      }
    } else {
      context.read<HostmiProvider>().filterForm.maritalStatus = [
        ...selectedMaritalStatus
      ];
    }

    if (selectedJobs.length == 1) {
      if (selectedJobs[0].id == 4) {
        context.read<HostmiProvider>().filterForm.occupations =
            context.read<HostmiProvider>().jobsList.map((e) {
          // print(e["id"]);
          return Job.fromMap(data: e);
        }).toList();
      }
    } else {
      context.read<HostmiProvider>().filterForm.occupations = [...selectedJobs];
    }

    if (selectedGenders.length == 1) {
      if (selectedGenders[0].id == 3) {
        context.read<HostmiProvider>().filterForm.genders =
            context.read<HostmiProvider>().gendersList.map((e) {
          // print(e["id"]);
          return Gender.fromMap(data: e);
        }).toList();
      }
    } else {
      context.read<HostmiProvider>().filterForm.genders = [...selectedGenders];
    }

    context.read<HostmiProvider>().filterForm.minPrice =
        double.tryParse(_minPriceController.text) ?? 0;
    context.read<HostmiProvider>().filterForm.maxPrice =
        double.tryParse(_maxPriceController.text) ?? 1000000;
    context.read<HostmiProvider>().filterForm.beds = numberOfBeds;
    context.read<HostmiProvider>().filterForm.bathrooms = numberOfBathRooms;
    context.read<HostmiProvider>().filterForm.categories = [
      ...selectedHouseCategory
    ];
    context.read<HostmiProvider>().filterForm.types = [...selectedHouseType];
    context.read<HostmiProvider>().filterForm.currency = selectedCurrency;
    context.read<HostmiProvider>().filterForm.priceType = selectedPriceType;
    context.read<HostmiProvider>().filterForm.features = [...selectedFeatures];
    context.read<HostmiProvider>().filterForm.country = selectedCountry;
    context.read<HostmiProvider>().filterForm.sectors =
        _getSearchIntArray(_sectorController.text);
    context.read<HostmiProvider>().filterForm.cities = _cityController.text;
    // _getSearchStringArray(_cityController.text);
    context.read<HostmiProvider>().filterForm.quarters =
        _getSearchStringArray(_quarterController.text);

    widget.onValidate?.call();
  }

  List<String> _getSearchStringArray(String text) {
    ///return an empty string if array is empty
    if (text.isEmpty) return ["%%"];
    final cities = text.replaceAll(" ", ",");
    final citiesArray = cities.split(",");
    final List<String> cArray = citiesArray.map((e) {
      if (e.isNotEmpty) {
        return "%$e%";
      }
      return "";
    }).toList();
    cArray.removeWhere((element) => element.isEmpty);

    return cArray;
  }

  List<int> _getSearchIntArray(String text) {
    if (text.isEmpty) return [];
    final numbersStr = text.replaceAll(RegExp(r'[^0-9]'), ",");
    final citiesArray = numbersStr.split(",");
    final List<int> cArray = citiesArray.map((e) {
      if (e.isNotEmpty) {
        return int.parse(e);
      }
      return 0;
    }).toList();
    cArray.removeWhere((element) => element == 0);

    return cArray;
  }

  void onSelectFeature(HouseFeatures feature) {
    setState(() {
      if (selectedFeatures.indexWhere((element) => element.id == feature.id) >=
          0) {
        selectedFeatures.retainWhere((element) => element.id != feature.id);
      } else {
        selectedFeatures.add(feature);
      }
    });
  }

  onSelectType(HouseType houseType) {
    setState(() {
      selectedHouseType.clear();
      selectedHouseType.add(houseType);
    });
  }

  onSelectCategory(HouseCategory category) {
    setState(() {
      selectedHouseCategory.clear();
      selectedHouseCategory.add(category);
    });
  }

  onSelectGender(Gender gender) {
    setState(() {
      selectedGenders.clear();
      selectedGenders.add(gender);
    });
  }

  onSelectMaritalStatus(MaritalStatus maritalStatus) {
    setState(() {
      selectedMaritalStatus.clear();
      selectedMaritalStatus.add(maritalStatus);
    });
  }

  onSelectJob(Job job) {
    setState(() {
      selectedJobs.clear();
      selectedJobs.add(job);
    });
  }
}
