import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hostmi/api/firebase/analytics_client.dart';
import 'package:hostmi/api/hostmi_local_database/hostmi_local_database.dart';
import 'package:hostmi/api/models/country_model.dart';
import 'package:hostmi/api/models/currency.dart';
import 'package:hostmi/api/models/filter_model.dart';
import 'package:hostmi/api/models/house_category.dart';
import 'package:hostmi/api/models/house_features.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/models/house_type.dart';
import 'package:hostmi/api/models/price_type.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/rest/houses/filters/filter_all.dart';
import 'package:hostmi/api/supabase/rest/houses/select_houses.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/alerts/filter_stack.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_new_property_select_amenities_screen/widgets/options_item_widget.dart';
import 'package:hostmi/ui/screens/filter_screen/filter_screen.dart';
import 'package:hostmi/ui/screens/filter_screen/widgets/listbeds_item_widget.dart';
import 'package:hostmi/ui/widgets/house_card.dart';
import 'package:hostmi/ui/widgets/house_card_shimmer.dart';
import 'package:hostmi/ui/widgets/action_button.dart';
import 'package:hostmi/ui/widgets/rounded_text_field.dart';
import 'package:hostmi/ui/widgets/search_dropdown.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/widgets/custom_drop_down.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key, this.index = 0, this.onAddHouse}) : super(key: key);
  final int index;
  final void Function()? onAddHouse;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
    with AutomaticKeepAliveClientMixin {
  final SizedBox _spacer = SizedBox(height: getVerticalSize(20));
  List<HouseType> selectedHouseType = [];
  List<HouseCategory> selectedHouseCategory = [];
  List<HouseFeatures> selectedFeatures = [];
  late TextEditingController _searchController;
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late final TextEditingController _sectorController;

  late Country selectedCountry;
  late PriceType selectedPriceType;
  late Currency selectedCurrency;
  late int numberOfBeds;
  late int numberOfBathRooms;
  List<HouseModel> houses = [];
  late ScrollController _controller;
  int _resultCount = 0;
  bool _isFirst = true;

  bool _showCategories = false;
  bool _showFeatures = false;
  bool _showTypes = false;
  bool _showPrices = false;
  bool _showCountries = false;
  bool _showBaths = false;
  bool _showBeds = false;
  bool _showSectors = false;
  bool _isAll = true;
  bool _showFilters = false;
  bool _isInputNotEmpty = true;
  bool _isLoading = true;

  static const _pageSize = 10;

  final PagingController<int, HouseModel> _pagingController =
      PagingController(firstPageKey: 0);
  String _country = 'Ouagadougou, Burkina Faso';

  @override
  void initState() {
    _searchController = TextEditingController();
    _minPriceController = TextEditingController();
    _maxPriceController = TextEditingController();
    _sectorController = TextEditingController();
    _sectorController.text = context
        .read<HostmiProvider>()
        .filterForm
        .sectors
        .map((e) => e)
        .join(", ");
    _minPriceController.text =
        context.read<HostmiProvider>().filterForm.minPrice.toString();
    _maxPriceController.text =
        context.read<HostmiProvider>().filterForm.maxPrice.toString();

    // .map((e) => e.replaceAll(r"%", ""))
    // .join(", ");
    numberOfBeds = context.read<HostmiProvider>().filterForm.beds;
    numberOfBathRooms = context.read<HostmiProvider>().filterForm.bathrooms;
    selectedCurrency = context.read<HostmiProvider>().filterForm.currency;
    selectedPriceType = context.read<HostmiProvider>().filterForm.priceType;
    selectedCountry = context.read<HostmiProvider>().filterForm.country;
    selectedHouseType = [...context.read<HostmiProvider>().filterForm.types];
    selectedHouseCategory = [
      ...context.read<HostmiProvider>().filterForm.categories
    ];
    selectedFeatures = [...context.read<HostmiProvider>().filterForm.features];
    // _searchController.text = "Burkina Faso";
    _controller = ScrollController();

    _getCountry().then((value) {
      if (_isFirst) {
        context.read<HostmiProvider>().filterForm.cities = _country;
      }

      _pagingController.addPageRequestListener((pageKey) {
        _fetchPage(context.read<HostmiProvider>().filterForm, pageKey);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HostmiProvider>().getPriceTypes();
      context.read<HostmiProvider>().getHouseTypes();
      context.read<HostmiProvider>().getHouseFeatures();
      context.read<HostmiProvider>().getHouseCategories();
      context.read<HostmiProvider>().getCurrencies();
      context.read<HostmiProvider>().getGenders();
      context.read<HostmiProvider>().getJobs();
      context.read<HostmiProvider>().getMaritalStatus();
      context.read<HostmiProvider>().getCountries();
    });

    var screen = MediaQuery.of(context).size;
    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SafeArea(
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: AppColor.grey,
                  appBar: PreferredSize(
                    preferredSize: const Size(double.infinity, 300),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "QUELLE MAISON CHERCHEZ VOUS ?",
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.grey[700]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: RoundedTextField(
                                  controller: _searchController,
                                  onChanged: (value) {
                                    context
                                        .read<HostmiProvider>()
                                        .filterForm
                                        .cities = "$value maison";
                                    if (value.isNotEmpty && !_isInputNotEmpty) {
                                      setState(() {
                                        _isInputNotEmpty = true;
                                      });
                                    } else if (value.isEmpty &&
                                        _isInputNotEmpty) {
                                      setState(() {
                                        _isInputNotEmpty = false;
                                      });
                                    }
                                    refresh();
                                  },
                                  errorText: "Saisi invalide",
                                  placeholder: "Que cherchez vous ?",
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: _isInputNotEmpty
                                      ? null
                                      : Align(
                                          widthFactor: double.minPositive,
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 25.0,
                                            ),
                                            child: RichText(
                                              text: const TextSpan(
                                                style: TextStyle(
                                                  color: AppColor.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                                children: <TextSpan>[
                                                  TextSpan(text: "Host"),
                                                  TextSpan(
                                                    text: "MI",
                                                    style: TextStyle(
                                                      color: AppColor.primary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                ),
                              ),
                              Semantics(
                                button: true,
                                label: "Filtrer les résultat",
                                onTap: () {
                                  analytics.logEvent(name: "Filter button");
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          FilterScreen(
                                        onValidate: () {
                                          setState(() {
                                            _isAll = false;
                                            refresh();
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: GestureDetector(
                                  onTap: () {
                                    analytics.logEvent(name: "Filter button");
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            FilterScreen(
                                          onValidate: () {
                                            setState(() {
                                              _isAll = false;
                                              refresh();
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 5.0),
                                    padding: getPadding(
                                      left: 12,
                                      top: 8.5,
                                      right: 12,
                                      bottom: 8.5,
                                    ),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[200]!),
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: AppColor.primary,
                                    ),
                                    child: const Icon(Icons.tune,
                                        color: AppColor.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _spacer,
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    top: 8.0,
                                    bottom: 15.0,
                                    right: 10),
                                child: Text(
                                  "Filtrer la liste ($_resultCount résultats)",
                                  style: const TextStyle(
                                      color: AppColor.listItemGrey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showFilters = !_showFilters;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _showFilters
                                        ? Colors.grey[200]
                                        : AppColor.primary,
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        _showFilters ? "Moins " : "PLus ",
                                        style: TextStyle(
                                            color: _showFilters
                                                ? null
                                                : AppColor.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Icon(
                                        _showFilters
                                            ? Icons.remove_circle_outline
                                            : Icons.add_circle_outline,
                                        color: _showFilters
                                            ? null
                                            : AppColor.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _showFilters
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ActionButton(
                                          backgroundColor: _isAll
                                              ? AppColor.primary
                                              : AppColor.primary
                                                  .withOpacity(.75),
                                          foregroundColor: Colors.white,
                                          padding: getPadding(all: 12),
                                          onPressed: () {
                                            setState(() {
                                              _isAll = true;
                                              refresh();
                                            });
                                          },
                                          text: "Tout",
                                        ),
                                        SearchDropdownButton(
                                          backgroundColor: _isAll
                                              ? AppColor.primary
                                                  .withOpacity(.75)
                                              : AppColor.primary,
                                          foregroundColor: Colors.white,
                                          onPressed: () {
                                            setState(() {
                                              _showTypes = true;
                                            });
                                          },
                                          text: context
                                              .watch<HostmiProvider>()
                                              .filterForm
                                              .types
                                              .first
                                              .fr!,
                                          subtileText: "Choisir",
                                        ),
                                        SearchDropdownButton(
                                          backgroundColor: _isAll
                                              ? AppColor.primary
                                                  .withOpacity(.75)
                                              : AppColor.primary,
                                          foregroundColor: Colors.white,
                                          onPressed: () {
                                            setState(() {
                                              _showCategories = true;
                                            });
                                          },
                                          text: context
                                              .watch<HostmiProvider>()
                                              .filterForm
                                              .categories
                                              .first
                                              .fr!,
                                          subtileText: "Choisir",
                                        ),
                                        SearchDropdownButton(
                                          backgroundColor: _isAll
                                              ? AppColor.primary
                                                  .withOpacity(.75)
                                              : AppColor.primary,
                                          foregroundColor: Colors.white,
                                          onPressed: () {
                                            setState(() {
                                              _showFeatures = true;
                                            });
                                          },
                                          text: "Caractéristiques",
                                          subtileText: context
                                                  .watch<HostmiProvider>()
                                                  .filterForm
                                                  .features
                                                  .isEmpty
                                              ? "Non défini"
                                              : "+${context.watch<HostmiProvider>().filterForm.features.length}",
                                        ),
                                        SearchDropdownButton(
                                          backgroundColor: _isAll
                                              ? AppColor.primary
                                                  .withOpacity(.75)
                                              : AppColor.primary,
                                          foregroundColor: Colors.white,
                                          onPressed: () {
                                            setState(() {
                                              _showCountries = true;
                                            });
                                          },
                                          text: context
                                              .read<HostmiProvider>()
                                              .filterForm
                                              .country
                                              .fr!,
                                          subtileText: "Choisir",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SearchDropdownButton(
                                            backgroundColor: _isAll
                                                ? AppColor.primary
                                                    .withOpacity(.75)
                                                : AppColor.primary,
                                            foregroundColor: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                _showPrices = true;
                                              });
                                            },
                                            text:
                                                "Prix ${context.read<HostmiProvider>().filterForm.priceType.fr}",
                                            subtileText:
                                                "Entre ${context.read<HostmiProvider>().filterForm.shortMinPrice} et ${context.read<HostmiProvider>().filterForm.shortMaxPrice} ${context.read<HostmiProvider>().filterForm.currency.currency}",
                                          ),
                                          SearchDropdownButton(
                                            backgroundColor: _isAll
                                                ? AppColor.primary
                                                    .withOpacity(.75)
                                                : AppColor.primary,
                                            foregroundColor: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                _showBeds = true;
                                              });
                                            },
                                            text: "Chambres",
                                            subtileText:
                                                "${context.read<HostmiProvider>().filterForm.beds < 0 ? 'Tous' : context.read<HostmiProvider>().filterForm.beds}",
                                          ),
                                          SearchDropdownButton(
                                            backgroundColor: _isAll
                                                ? AppColor.primary
                                                    .withOpacity(.75)
                                                : AppColor.primary,
                                            foregroundColor: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                _showBaths = true;
                                              });
                                            },
                                            text: "Douches",
                                            subtileText:
                                                "${context.read<HostmiProvider>().filterForm.bathrooms < 0 ? 'Tous' : context.read<HostmiProvider>().filterForm.bathrooms}",
                                          ),
                                          SearchDropdownButton(
                                            backgroundColor: _isAll
                                                ? AppColor.primary
                                                    .withOpacity(.75)
                                                : AppColor.primary,
                                            foregroundColor: Colors.white,
                                            onPressed: () {
                                              setState(() {
                                                _showSectors = true;
                                              });
                                            },
                                            text: "Secteurs",
                                            subtileText: context
                                                    .read<HostmiProvider>()
                                                    .filterForm
                                                    .sectors
                                                    .isEmpty
                                                ? 'Tous'
                                                : context
                                                    .read<HostmiProvider>()
                                                    .filterForm
                                                    .sectors
                                                    .map((e) => e)
                                                    .join(", "),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                  body: Stack(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          Future.sync(() {
                            refresh();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: CustomScrollView(
                            slivers: [
                              PagedSliverList(
                                  pagingController: _pagingController,
                                  builderDelegate:
                                      PagedChildBuilderDelegate<HouseModel>(
                                    animateTransitions: true,
                                    firstPageErrorIndicatorBuilder: (context) {
                                      return Center(
                                          child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 50.0,
                                                horizontal: 10.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                    "Une erreur s'est produite"),
                                                const SizedBox(height: 20),
                                                TextButton(
                                                  onPressed: () {
                                                    refresh();
                                                  },
                                                  child:
                                                      const Text("Rééssayer"),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ));
                                    },
                                    newPageErrorIndicatorBuilder: (context) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              _pagingController
                                                  .retryLastFailedRequest();
                                            },
                                            icon: const Icon(
                                              Icons
                                                  .replay_circle_filled_rounded,
                                              size: 40,
                                              color: AppColor.primary,
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                    firstPageProgressIndicatorBuilder:
                                        (context) {
                                      return Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Column(
                                            children: List.generate(
                                              2,
                                              (index) =>
                                                  const HouseCardShimmer(),
                                              growable: false,
                                            ).animate(
                                              onComplete: (controller) {
                                                controller.repeat();
                                              },
                                            ).shimmer(
                                                blendMode: BlendMode.colorDodge,
                                                duration: 1000.ms,
                                                color: Colors.white54),
                                          ),
                                        )
                                      ]);
                                    },
                                    newPageProgressIndicatorBuilder: (context) {
                                      return Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                          ),
                                          child: Column(
                                            children: List.generate(
                                              2,
                                              (index) =>
                                                  const HouseCardShimmer(),
                                              growable: false,
                                            ).animate(
                                              onComplete: (controller) {
                                                controller.repeat();
                                              },
                                            ).shimmer(
                                                blendMode: BlendMode.colorDodge,
                                                duration: 1000.ms,
                                                color: Colors.white54),
                                          ),
                                        )
                                      ]);
                                    },
                                    noItemsFoundIndicatorBuilder: (context) {
                                      return const Center(
                                          child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.hide_image,
                                            size: 40,
                                            color: AppColor.primary,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("Aucun résultat.")
                                        ],
                                      ));
                                    },
                                    itemBuilder: (context, item, index) {
                                      return HouseCard(
                                        house: item,
                                      );
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  floatingActionButton: getData(keyAgencyDetails) == null
                      ? FloatingActionButton(
                          onPressed: widget.onAddHouse,
                          child: const Icon(Icons.add_home_outlined),
                        )
                      : null,
                ),
                _showCategories
                    ? FilterStack(
                        title: "Catégories",
                        onCancel: () {
                          setState(() {
                            _showCategories = false;
                            selectedHouseCategory = [
                              ...context
                                  .read<HostmiProvider>()
                                  .filterForm
                                  .categories
                            ];
                          });
                        },
                        onValidate: () async {
                          if (_isFirst) {
                            context.read<HostmiProvider>().resetFilters();
                            _isFirst = false;
                          }
                          setState(() {
                            _showCategories = false;
                            _isAll = false;
                            context
                                .read<HostmiProvider>()
                                .filterForm
                                .categories = [...selectedHouseCategory];
                          });
                          refresh();
                        },
                        screen: screen,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: getVerticalSize(5),
                          spacing: getHorizontalSize(5),
                          children: context
                              .read<HostmiProvider>()
                              .houseCategoriesList
                              .map((category) => OptionsItemWidget(
                                    amenity: category,
                                    selected: selectedHouseCategory
                                        .map((e) => e.id!)
                                        .toList(),
                                    onPressed: () => onSelectCategory(
                                        HouseCategory.fromMap(data: category)),
                                  ))
                              .toList(),
                        ))
                    : const SizedBox(),
                _showFeatures
                    ? FilterStack(
                        title: "Caractéristiques",
                        onCancel: () {
                          setState(() {
                            _showFeatures = false;
                            selectedFeatures = [
                              ...context
                                  .read<HostmiProvider>()
                                  .filterForm
                                  .features
                            ];
                          });
                        },
                        onValidate: () {
                          if (_isFirst) {
                            context.read<HostmiProvider>().resetFilters();
                            _isFirst = false;
                          }
                          setState(() {
                            _showFeatures = false;
                            _isAll = false;
                            context.read<HostmiProvider>().filterForm.features =
                                [...selectedFeatures];
                          });
                          refresh();
                        },
                        screen: screen,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: getVerticalSize(5),
                          spacing: getHorizontalSize(5),
                          children: context
                              .read<HostmiProvider>()
                              .houseFeaturesList
                              .map((feature) => OptionsItemWidget(
                                    amenity: feature,
                                    selected: selectedFeatures
                                        .map((e) => e.id!)
                                        .toList(),
                                    onPressed: () => onSelectFeature(
                                        HouseFeatures.fromMap(data: feature)),
                                  ))
                              .toList(),
                        ))
                    : const SizedBox(),
                _showTypes
                    ? FilterStack(
                        title: "Types de maison",
                        onCancel: () {
                          setState(() {
                            _showTypes = false;
                            selectedHouseType = [
                              ...context.read<HostmiProvider>().filterForm.types
                            ];
                          });
                        },
                        onValidate: () {
                          if (_isFirst) {
                            context.read<HostmiProvider>().resetFilters();
                            _isFirst = false;
                          }
                          setState(() {
                            _showTypes = false;
                            _isAll = false;
                            context.read<HostmiProvider>().filterForm.types = [
                              ...selectedHouseType
                            ];
                          });

                          refresh();
                        },
                        screen: screen,
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
                        ),
                      )
                    : const SizedBox(),
                _showPrices
                    ? FilterStack(
                        title: "Configurer le prix",
                        onCancel: () {
                          setState(() {
                            _showPrices = false;
                            // selectedHouseType = [
                            //   ...context.read<HostmiProvider>().filterForm.types
                            // ];
                          });
                        },
                        onValidate: () {
                          if (_isFirst) {
                            context.read<HostmiProvider>().resetFilters();
                            _isFirst = false;
                          }
                          setState(() {
                            _showPrices = false;
                            _isAll = false;
                            context.read<HostmiProvider>().filterForm.minPrice =
                                double.tryParse(_minPriceController.text) ?? 0;
                            context.read<HostmiProvider>().filterForm.maxPrice =
                                double.tryParse(_maxPriceController.text) ??
                                    1000000;

                            context.read<HostmiProvider>().filterForm.currency =
                                selectedCurrency;
                            context
                                .read<HostmiProvider>()
                                .filterForm
                                .priceType = selectedPriceType;
                            // context.read<HostmiProvider>().filterForm.types = [
                            //   ...selectedHouseType
                            // ];
                          });

                          refresh();
                        },
                        screen: screen,
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
                                    fontStyle: DropDownFontStyle
                                        .ManropeMedium14Bluegray500,
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
                                            svgPath: ImageConstant
                                                .imgArrowdownGray900)),
                                    margin: getMargin(top: 12),
                                    variant: DropDownVariant.FillBluegray50,
                                    fontStyle: DropDownFontStyle
                                        .ManropeMedium14Bluegray500,
                                    items: context
                                        .watch<HostmiProvider>()
                                        .currenciesList
                                        .map((currency) {
                                      return DropdownMenuItem<Currency>(
                                          value:
                                              Currency.fromMap(data: currency),
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
                            ]),
                      )
                    : const SizedBox(),
                //Filter of countries
                _showCountries
                    ? FilterStack(
                        title: "Pays",
                        onCancel: () {
                          setState(() {
                            _showCountries = false;
                          });
                        },
                        onValidate: () {
                          if (_isFirst) {
                            context.read<HostmiProvider>().resetFilters();
                            _isFirst = false;
                          }
                          setState(() {
                            _showCountries = false;
                            _isAll = false;
                          });
                          context.read<HostmiProvider>().filterForm.country =
                              selectedCountry;
                          refresh();
                        },
                        screen: screen,
                        child: CustomDropDown<Country>(
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
                            }))
                    : const SizedBox(),
                //Filter of number of piece
                _showBeds
                    ? FilterStack(
                        title: "Chambres",
                        onCancel: () {
                          setState(() {
                            _showBeds = false;
                          });
                        },
                        onValidate: () {
                          if (_isFirst) {
                            context.read<HostmiProvider>().resetFilters();
                            _isFirst = false;
                          }
                          setState(() {
                            _showBeds = false;
                            _isAll = false;
                          });
                          context.read<HostmiProvider>().filterForm.beds =
                              numberOfBeds;
                          refresh();
                        },
                        screen: screen,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: getPadding(top: 25),
                              child: ListbedsItemWidget(
                                  showSpace: false,
                                  label: '',
                                  value: numberOfBeds,
                                  onDecrease: () {
                                    setState(() {
                                      numberOfBeds = numberOfBeds > 0
                                          ? numberOfBeds - 1
                                          : -1;
                                    });
                                  },
                                  onIncrease: () {
                                    setState(() {
                                      numberOfBeds = numberOfBeds + 1;
                                    });
                                  }),
                            ),
                          ],
                        ))
                    : const SizedBox(),
                _showBaths
                    ? FilterStack(
                        title: "Douches",
                        onCancel: () {
                          setState(() {
                            _showBaths = false;
                          });
                        },
                        onValidate: () {
                          if (_isFirst) {
                            context.read<HostmiProvider>().resetFilters();
                            _isFirst = false;
                          }
                          setState(() {
                            _showBaths = false;
                            _isAll = false;
                          });
                          context.read<HostmiProvider>().filterForm.bathrooms =
                              numberOfBathRooms;
                        },
                        screen: screen,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: getPadding(top: 25),
                              child: ListbedsItemWidget(
                                  label: '',
                                  value: numberOfBathRooms,
                                  showSpace: false,
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
                          ],
                        ))
                    : const SizedBox(),
                _showSectors
                    ? FilterStack(
                        title: "Secteurs",
                        onCancel: () {
                          setState(() {
                            _showSectors = false;
                          });
                        },
                        onValidate: () {
                          if (_isFirst) {
                            context.read<HostmiProvider>().resetFilters();
                            _isFirst = false;
                          }
                          setState(() {
                            _showSectors = false;
                            _isAll = false;
                          });
                          context.read<HostmiProvider>().filterForm.sectors =
                              _getSearchIntArray(_sectorController.text);
                          refresh();
                        },
                        screen: screen,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: getPadding(top: 6),
                              child: CustomTextFormField(
                                controller: _sectorController,
                                hintText: "Ex : 1, 2, 12, etc...",
                                margin: getMargin(top: 13),
                                textInputType: TextInputType.text,
                              ),
                            ),
                          ],
                        ))
                    : const SizedBox(),
              ],
            ),
          );
  }

  Future<void> _fetchPage(FilterModel filters, int pageKey) async {
    //   _resultCount = 0;
    try {
      final response = _isAll
          ? await selectHouses(
              from: pageKey,
              to: _pageSize,
              cities: context.read<HostmiProvider>().filterForm.cities)
          : await filterAllHousesAttributes(
              filters: filters, from: pageKey, to: _pageSize);
      final List<dynamic> list = response!.data;
      print(list.runtimeType.toString());
      final newItems = list.map((e) => HouseModel.fromMap(e)).toList();
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }

      _resultCount = response.count!;
    } catch (error) {
      _pagingController.error = error;
    }
    setState(() {});
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

  onSelectType(HouseType houseType) {
    setState(() {
      selectedHouseType.clear();
      selectedHouseType.add(houseType);
    });
  }

  onSelectCategory(HouseCategory category) {
    setState(() {
      selectedHouseCategory = [category];
    });
  }

  Future<void> refresh() async {
    _pagingController.refresh();
  }

  Future<void> _getCountry() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Reverse geocode the coordinates to get the country.
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      setState(() {
        _country = placemarks[0].country != null
            ? "${placemarks[0].locality}, ${placemarks[0].country}"
            : _country;
        _isLoading = false;
      });

      debugPrint(
          "Country: ${placemarks[0].country}; Lieu: ${placemarks[0].locality}");
    }
    _searchController.text = _country;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
