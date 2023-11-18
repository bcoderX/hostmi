import 'package:flutter/scheduler.dart';
import 'package:hostmi/api/models/currency.dart';
import 'package:hostmi/api/models/price_type.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_new_property_select_amenities_screen/widgets/options_item_widget.dart';
import 'package:hostmi/ui/widgets/range_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_drop_down.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

import '../filter_screen/widgets/listbeds_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/custom_bottom_bar.dart';
import 'package:hostmi/widgets/custom_button.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final _spacer = const SizedBox(
    height: 20,
  );

  List<int> selectedHouseType = [];
  List<int> selectedHouseCategory = [];
  List<int> selectedFeatures = [];

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  final TextEditingController minPriceController = TextEditingController();

  final TextEditingController maxPriceController = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  final TextEditingController quarterController = TextEditingController();

  final TextEditingController sectorController = TextEditingController();

  int selectedPriceType = 1;

  int selectedCurrency = 159;

  int numberOfBeds = 0;

  int numberOfBathRooms = 0;

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HostmiProvider>().getPriceTypes();
      context.read<HostmiProvider>().getHouseFeatures();
      context.read<HostmiProvider>().getHouseCategories();
      context.read<HostmiProvider>().getCurrencies();
    });
    return Scaffold(
      backgroundColor: ColorConstant.gray50,
      appBar: AppBar(
        leading: InkWell(
          child: const Icon(Icons.cancel),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        // systemOverlayStyle: const SystemUiOverlayStyle(
        //   statusBarBrightness: Brightness.light,
        // ),
        title: const Text(
          "Filtrer",
          style: TextStyle(color: AppColor.black),
        ),
        actions: [
          TextButton.icon(
              onPressed: () {
                // _showOptionDialog();
              },
              icon: const Icon(
                Icons.check,
                color: AppColor.primary,
                size: 20,
              ),
              label: const Text("Appliquer"))
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
            child: Container(
                decoration: AppDecoration.fillGray9007e,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                      width: double.maxFinite,
                      child: Container(
                          margin: getMargin(top: 16),
                          decoration: AppDecoration.fillGray50,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: getPadding(left: 24, right: 24),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          "Prix",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: AppColor.listItemGrey,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: DropdownButtonFormField<
                                              PriceType>(
                                        value: context
                                            .read<HostmiProvider>()
                                            .houseForm
                                            .priceType,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        items: context
                                            .watch<HostmiProvider>()
                                            .priceTypesList
                                            .map((priceType) {
                                          return DropdownMenuItem<PriceType>(
                                              value: PriceType.fromMap(
                                                  data: priceType),
                                              child: Text(
                                                priceType["fr"].toString(),
                                                overflow: TextOverflow.ellipsis,
                                              ));
                                        }).toList(),
                                        onChanged: (value) {
                                          selectedPriceType = value!.id!;
                                        },
                                      ))
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: getPadding(
                                    top: 7,
                                  ),
                                  child: RangeField(
                                    rangeValues:
                                        const RangeValues(0, 1000000.0),
                                    minTextController: minPriceController,
                                    maxTextController: maxPriceController,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      getPadding(left: 24, top: 25, right: 24),
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
                                  padding:
                                      getPadding(left: 24, top: 7, right: 24),
                                  child: CustomDropDown<Currency>(
                                      value: context
                                          .read<HostmiProvider>()
                                          .houseForm
                                          .currency,
                                      //focusNode: FocusNode(),
                                      icon: Container(
                                          margin:
                                              getMargin(left: 30, right: 16),
                                          child: CustomImageView(
                                              svgPath: ImageConstant
                                                  .imgArrowdownGray900)),
                                      hintText: "Choisir une monnaie",
                                      margin: getMargin(top: 12),
                                      variant: DropDownVariant.FillBluegray50,
                                      fontStyle: DropDownFontStyle
                                          .ManropeMedium14Bluegray500,
                                      items: context
                                          .watch<HostmiProvider>()
                                          .currenciesList
                                          .map((currency) {
                                        return DropdownMenuItem<Currency>(
                                            value: Currency.fromMap(
                                                data: currency),
                                            child: Text(
                                              "${currency["currency"] + ' - ' + currency["en"]}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ));
                                      }).toList(),
                                      onChanged: (value) {
                                        selectedCurrency = value.id!;
                                      }),
                                ),
                                _spacer,
                                Container(
                                  width: double.infinity,
                                  height: 15,
                                  color: Colors.grey[200],
                                ),
                                Padding(
                                  padding:
                                      getPadding(left: 24, top: 25, right: 24),
                                  child: ListbedsItemWidget(
                                      label: 'Nombre de chambres',
                                      value: numberOfBeds,
                                      onDecrease: () {
                                        setState(() {
                                          numberOfBeds = numberOfBeds > 0
                                              ? numberOfBeds - 1
                                              : 0;
                                        });
                                      },
                                      onIncrease: () {
                                        setState(() {
                                          numberOfBeds = numberOfBeds + 1;
                                        });
                                      }),
                                ),
                                Padding(
                                  padding:
                                      getPadding(left: 24, top: 7, right: 24),
                                  child: ListbedsItemWidget(
                                      label: 'Nombre de douches',
                                      value: numberOfBathRooms,
                                      onDecrease: () {
                                        setState(() {
                                          numberOfBathRooms =
                                              numberOfBathRooms > 0
                                                  ? numberOfBathRooms - 1
                                                  : 0;
                                        });
                                      },
                                      onIncrease: () {
                                        setState(() {
                                          numberOfBathRooms =
                                              numberOfBathRooms + 1;
                                        });
                                      }),
                                ),
                                _spacer,
                                Container(
                                  width: double.infinity,
                                  height: 15,
                                  color: Colors.grey[200],
                                ),
                                Padding(
                                    padding: getPadding(
                                        left: 24, top: 25, right: 24),
                                    child: Text("Lieux",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeExtraBold16Gray900
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2)))),
                                Padding(
                                    padding: getPadding(left: 24, top: 17),
                                    child: Text("Ville",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeSemiBold14Gray900)),
                                Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: getPadding(
                                          left: 24, top: 6, right: 24),
                                      child: CustomTextFormField(
                                        controller: cityController,
                                        hintText: "Saisir une ville",
                                        margin: getMargin(top: 13),
                                        textInputType: TextInputType.text,
                                      ),
                                    )),
                                Padding(
                                    padding: getPadding(left: 24, top: 17),
                                    child: Text("Quartier",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeSemiBold14Gray900)),
                                Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: getPadding(
                                          left: 24, top: 6, right: 24),
                                      child: CustomTextFormField(
                                        controller: quarterController,
                                        hintText: "Saisir un quartier",
                                        margin: getMargin(top: 13),
                                        textInputType: TextInputType.text,
                                      ),
                                    )),
                                Padding(
                                    padding: getPadding(left: 24, top: 17),
                                    child: Text("Secteur",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeSemiBold14Gray900)),
                                Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: getPadding(
                                          left: 24, top: 6, right: 24),
                                      child: CustomTextFormField(
                                        controller: sectorController,
                                        hintText: "Saisir un secteur",
                                        margin: getMargin(top: 13),
                                        textInputType: TextInputType.number,
                                      ),
                                    )),
                                _spacer,
                                Container(
                                  width: double.infinity,
                                  height: 15,
                                  color: Colors.grey[200],
                                ),
                                Padding(
                                    padding: getPadding(left: 24, top: 27),
                                    child: Text("Type de maison",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeExtraBold16Gray900
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2)))),
                                Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                        padding: getPadding(top: 14),
                                        child: Wrap(
                                          runSpacing: getVerticalSize(5),
                                          spacing: getHorizontalSize(5),
                                          children: context
                                              .watch<HostmiProvider>()
                                              .houseTypesList
                                              .map((houseType) =>
                                                  OptionsItemWidget(
                                                    amenity: houseType,
                                                    selected: selectedHouseType,
                                                    onPressed: () =>
                                                        onSelectType(
                                                            houseType["id"]),
                                                  ))
                                              .toList(),
                                        ))),
                                _spacer,
                                Container(
                                  width: double.infinity,
                                  height: 15,
                                  color: Colors.grey[200],
                                ),
                                Padding(
                                    padding: getPadding(left: 24, top: 27),
                                    child: Text("Catégories de maison",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeExtraBold16Gray900
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2)))),
                                Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                        padding: getPadding(top: 14),
                                        child: Wrap(
                                          runSpacing: getVerticalSize(5),
                                          spacing: getHorizontalSize(5),
                                          children: context
                                              .watch<HostmiProvider>()
                                              .houseCategoriesList
                                              .map((category) =>
                                                  OptionsItemWidget(
                                                    amenity: category,
                                                    selected:
                                                        selectedHouseCategory,
                                                    onPressed: () =>
                                                        onSelectCategory(
                                                            category["id"]),
                                                  ))
                                              .toList(),
                                        ))),
                                _spacer,
                                Container(
                                  width: double.infinity,
                                  height: 15,
                                  color: Colors.grey[200],
                                ),
                                Padding(
                                    padding: getPadding(left: 24, top: 25),
                                    child: Row(children: [
                                      Text("Caractéristiques",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtManropeExtraBold16Gray900
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2))),
                                      // CustomImageView(
                                      //     svgPath: ImageConstant.imgWarning,
                                      //     height: getSize(20),
                                      //     width: getSize(20),
                                      //     margin:
                                      //         getMargin(left: 26, bottom: 1))
                                    ])),
                                Padding(
                                    padding: getPadding(left: 24, top: 16),
                                    child: Wrap(
                                      runSpacing: getVerticalSize(5),
                                      spacing: getHorizontalSize(5),
                                      children: context
                                          .watch<HostmiProvider>()
                                          .houseFeaturesList
                                          .map((feature) => OptionsItemWidget(
                                                amenity: feature,
                                                selected: selectedFeatures,
                                                onPressed: () =>
                                                    onSelectFeature(
                                                        feature["id"]),
                                              ))
                                          .toList(),
                                    )),
                                Padding(
                                    padding: getPadding(left: 24, top: 16),
                                    child: Row(children: [
                                      Text("See More",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle
                                              .txtManropeBold14Blue500
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2))),
                                      CustomImageView(
                                          svgPath:
                                              ImageConstant.imgArrowright16x16,
                                          height: getSize(16),
                                          width: getSize(16),
                                          margin: getMargin(
                                              left: 8, top: 1, bottom: 2))
                                    ])),
                                Container(
                                    width: double.maxFinite,
                                    margin: getMargin(top: 24),
                                    padding: getPadding(all: 24),
                                    decoration:
                                        AppDecoration.outlineBluegray1000f,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: CustomButton(
                                                  height: getVerticalSize(56),
                                                  text: "Rénitialiser",
                                                  margin: getMargin(right: 7),
                                                  variant: ButtonVariant
                                                      .OutlineBlue500_2,
                                                  shape: ButtonShape
                                                      .RoundedBorder10,
                                                  padding: ButtonPadding
                                                      .PaddingAll16,
                                                  fontStyle: ButtonFontStyle
                                                      .ManropeBold16Blue500_1)),
                                          Expanded(
                                              child: CustomButton(
                                                  height: getVerticalSize(56),
                                                  text: "Appliquer",
                                                  margin: getMargin(left: 7),
                                                  shape: ButtonShape
                                                      .RoundedBorder10,
                                                  padding: ButtonPadding
                                                      .PaddingAll16,
                                                  fontStyle: ButtonFontStyle
                                                      .ManropeBold16WhiteA700_1))
                                        ]))
                              ])))
                ]))),
      ),
      // bottomNavigationBar: CustomBottomBar(onChanged: (BottomBarEnum type) {
      //   Navigator.pushNamed(
      //     navigatorKey.currentContext!,
      //     getCurrentRoute(type),
      //   );
      // }),
    );
  }

  ///Handling route based on bottom click actions
  String getCurrentRoute(BottomBarEnum type) {
    switch (type) {
      /* case BottomBarEnum.Home:
        return AppRoutes.homePage;
      case BottomBarEnum.Message:
        return AppRoutes.messagePage;
      case BottomBarEnum.Discover:
        return AppRoutes.homeSearchPage;
      case BottomBarEnum.Myhome:
        return AppRoutes.myHomePage;
      case BottomBarEnum.Profile:
        return AppRoutes.profilePage;*/
      default:
        return "/";
    }
  }

  ///Handling page based on route
  Widget getCurrentPage(String currentRoute) {
    switch (currentRoute) {
      /* case AppRoutes.homePage:
        return HomePage();
      case AppRoutes.messagePage:
        return MessagePage();
      case AppRoutes.homeSearchPage:
        return HomeSearchPage();
      case AppRoutes.myHomePage:
        return MyHomePage();
      case AppRoutes.profilePage:
        return ProfilePage();*/
      default:
        return DefaultWidget();
    }
  }

  onTapBtnClose(BuildContext context) {
    Navigator.pop(context);
  }

  onSelectFeature(int index) {
    setState(() {
      if (selectedFeatures.contains(index)) {
        selectedFeatures.remove(index);
      } else {
        selectedFeatures.add(index);
      }
    });
  }

  onSelectType(int index) {
    setState(() {
      if (selectedHouseType.contains(index)) {
        selectedHouseType.remove(index);
      } else {
        selectedHouseType.add(index);
      }
    });
  }

  onSelectCategory(int index) {
    setState(() {
      if (selectedHouseCategory.contains(index)) {
        selectedHouseCategory.remove(index);
      } else {
        selectedHouseCategory.add(index);
      }
    });
  }
}
