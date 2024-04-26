import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/models/database_response.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/models/house_type.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/rest/houses/filters/get_nearby_houses.dart';
import 'package:hostmi/api/supabase/rest/houses/select_houses.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/api/utils/check_connection_and_do.dart';
import 'package:hostmi/api/utils/check_internet_status.dart';
import 'package:hostmi/core/utils/image_constant.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/theme/app_style.dart';
import 'package:hostmi/ui/screens/loading_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hostmi/ui/widgets/action_button.dart';
import 'package:hostmi/ui/widgets/default_app_button.dart';
import 'package:hostmi/ui/widgets/house_card.dart';
import 'package:hostmi/ui/widgets/house_card_shimmer.dart';
import 'package:hostmi/ui/widgets/rounded_text_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hostmi/widgets/custom_drop_down.dart';
import 'package:hostmi/widgets/custom_image_view.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:safe_device/safe_device.dart';

class MapWelcome extends StatefulWidget {
  const MapWelcome({Key? key, this.latitude, this.longitude, this.placeName})
      : super(key: key);
  final double? latitude;
  final double? longitude;
  final String? placeName;

  @override
  State<MapWelcome> createState() => _MapWelcomeState();
}

class _MapWelcomeState extends State<MapWelcome>
    with AutomaticKeepAliveClientMixin {
  late final MapController _mapController;
  late final TextEditingController _editingController;
  late final TextEditingController _distanceController;
  final GlobalKey<FormState> _formState = GlobalKey();
  bool isFirst=true;
  List<HouseModel> _points = [];
  LatLng? _center;
  bool _isFullScreen = false;
  bool _isSearching = false;
  bool _showResult = false;
  bool _isRelocating = false;
  bool _isLoading = false;
  int _lastSearchLength = 0;
  int selectedHouseType = 0;
  int tempType = 0;
  DatabaseDynamicResponse response = const DatabaseDynamicResponse();
  double _zoom = 13.2;
  Future<DatabaseResponse>? _houseFuture;
  late DraggableScrollableController _scrollController;
  @override
  void initState() {
    _mapController = MapController();
    _editingController = TextEditingController();
    _distanceController = TextEditingController();
    _scrollController = DraggableScrollableController();
    _getSearchLocation();
    _distanceController.text = "30000";

    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _getSearchLocation() async {
    bool isNotInit = _center != null;
    if (widget.latitude != null && widget.longitude != null) {
      _center = LatLng(widget.latitude!, widget.longitude!);
      _editingController.text = widget.placeName!;
      if (isNotInit) {
        Future.delayed(
          2.seconds,
          () {
            setState(() {
              _isRelocating = false;
            });
          },
        );
      }
      bool isConnected = await checkInternetStatus();
      if (isConnected) {
        if (!response.isSuccess) {
          response = await getAllNearbyHouses(
              _center!, double.tryParse(_distanceController.text) ?? 30000);
          if (response.isSuccess) {
            Timer(2000.ms, () {
              showResults();
              Fluttertoast.showToast(
                  msg: "${response.list!.length} résultats trouvés...",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.grey,
                  textColor: Colors.white,
                  fontSize: 16.0);
            });
          } else {
            Fluttertoast.showToast(
                msg: "Vérifiez votre connexion internet...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        }
      }
    }
  }

  void _getLocation() async {
    final latlng = await checkPermissionAndGetLocation();
    bool isConnected = await checkInternetStatus();
    if (isConnected) {
      if (!response.isSuccess) {
        response = await getAllNearbyHouses(
            latlng!, double.tryParse(_distanceController.text) ?? 30000);
        if (response.isSuccess) {
          Timer(2000.ms, () {
            showResults();
            Fluttertoast.showToast(
                msg: "${response.list!.length} résultats trouvés...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
          });
        } else {
          Fluttertoast.showToast(
              msg: "Vérifiez votre connexion internet...",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }
    setState(() {
      _center = latlng;
    });
  }

  Future<LatLng?> checkPermissionAndGetLocation() async {
    bool isRealDevice = await SafeDevice.isRealDevice;
    if (isRealDevice) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LatLng(12.253609, -2.378845);
        } else if (permission == LocationPermission.deniedForever) {
          return LatLng(12.253609, -2.378845);
        } else {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          return LatLng(position.latitude, position.longitude);
          //_mapController.move(_center, _zoom);
        }
      } else {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.bestForNavigation);
        return LatLng(position.latitude, position.longitude);
      }
    }
    return LatLng(12.253609, -2.378845);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size screenSize = MediaQuery.of(context).size;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        context.read<HostmiProvider>().getHouseTypes();
      if (_center == null && isFirst) {
        _getLocation();
        isFirst=false;
      }
    });

    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            minHeight: screenSize.height,
          ),
          child: Column(
            children: [
              _isFullScreen
                  ? const SizedBox()
                  : Container(
                      constraints: BoxConstraints(
                        minHeight: screenSize.height * 0.4,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColor.primary,
                        image: DecorationImage(
                          image: AssetImage("assets/images/5.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 25.0, horizontal: 5),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.welcome,
                              style: const TextStyle(
                                color: AppColor.grey,
                                fontFamily: 'Manrope',
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!.welcomeSlogan,
                              style: const TextStyle(
                                color: AppColor.grey,
                                fontFamily: 'Manrope',
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Semantics(
                              textField: true,
                              label: "Chercher un lieu",
                              onTap: () {
                                context.push("/search-place");
                              },
                              child: RoundedTextField(
                                onTap: () {
                                  context.push("/search-place");
                                },
                                isReadOnly: true,
                                controller: _editingController,
                                errorText: "errorText",
                                placeholder: "Chercher un lieu",
                                prefixIcon: const Icon(Icons.search),
                                suffixIcon: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isRelocating = true;
                                      });
                                      _getSearchLocation();
                                      setState(() {
                                        _isRelocating = false;
                                      });
                                    },
                                    child: const Text("HostMi"),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              Expanded(
                child: _center == null || _isRelocating
                    ? const BallLoadingPage(
                        loadingTitle: "Chargement de la carte...",
                      )
                    : FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                            center: _center,
                            zoom: _zoom,
                            onMapReady: () {
                              _mapController.mapEventStream.listen((event) {
                                setState(() {
                                  _zoom = event.zoom;
                                  _center = event.center;
                                });
                              });
                            },
                            onTap: (TapPosition p, LatLng lt) {}),
                        nonRotatedChildren: [
                          const RichAttributionWidget(
                            alignment: AttributionAlignment.bottomLeft,
                            animationConfig:
                                ScaleRAWA(), // Or `FadeRAWA` as is default
                            attributions: [
                              TextSourceAttribution(
                                'OpenStreetMap contributors',
                                // onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _isFullScreen
                                    ? SafeArea(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RoundedTextField(
                                            controller: _editingController,
                                            isReadOnly: true,
                                            onTap: () {
                                              context.push("/search-place");
                                            },
                                            errorText: "errorText",
                                            placeholder: "Chercher un lieu",
                                            prefixIcon:
                                                const Icon(Icons.search),
                                            suffixIcon: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isRelocating = true;
                                                });
                                                _getSearchLocation();
                                                setState(() {
                                                  _isRelocating = false;
                                                });
                                              },
                                              child: const Text("HostMi"),
                                            ),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 3, left: 1),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ActionButton(
                                                    backgroundColor:
                                                        selectedHouseType == 0
                                                            ? AppColor.primary
                                                            : Colors.white,
                                                    foregroundColor:
                                                        selectedHouseType == 0
                                                            ? Colors.white
                                                            : Colors.black,
                                                    onPressed: () async {
                                                      bool isConnected =
                                                          await checkInternetStatus();
                                                      if (isConnected) {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Recherche en cours...",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                Colors.grey,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);

                                                        setState(() {
                                                          _points = [];
                                                          selectedHouseType = 0;
                                                        });
                                                        response =
                                                            await getAllNearbyHouses(
                                                          _center!,
                                                          double.tryParse(
                                                                  _distanceController
                                                                      .text) ??
                                                              30000,
                                                        );

                                                        if (response
                                                            .isSuccess) {
                                                          Timer(2000.ms, () {
                                                            showResults();
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "${response.list!.length} résultats trouvé(s)",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors.grey,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);
                                                          });
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Vérifiez votre connexion internet...",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                Colors.grey,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      }
                                                    },
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10, top: 5),
                                                    padding:
                                                        getPadding(all: 12),
                                                    text: "Tout"),
                                                ...context
                                                    .read<HostmiProvider>()
                                                    .houseTypesList
                                                    .map((e) {
                                                  return ActionButton(
                                                    backgroundColor:
                                                        selectedHouseType ==
                                                                e["id"]
                                                            ? AppColor.primary
                                                            : Colors.white,
                                                    foregroundColor:
                                                        selectedHouseType ==
                                                                e["id"]
                                                            ? Colors.white
                                                            : Colors.black,
                                                    onPressed: () async {
                                                      bool isConnected =
                                                          await checkInternetStatus();
                                                      if (isConnected) {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Recherche en cours...",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                Colors.grey,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                        setState(() {
                                                          _points = [];
                                                          selectedHouseType =
                                                              e["id"];
                                                        });
                                                        response = await getNearbyHouses(
                                                            _center!,
                                                            double.tryParse(
                                                                    _distanceController
                                                                        .text) ??
                                                                30000,
                                                            selectedHouseType);

                                                        if (response
                                                            .isSuccess) {
                                                          Timer(2000.ms, () {
                                                            showResults();
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "${response.list!.length} résultats trouvés...",
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors.grey,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);
                                                          });
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Vérifiez votre connexion internet...",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                Colors.grey,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      }
                                                    },
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10, top: 5),
                                                    text: e["fr"],
                                                    padding:
                                                        getPadding(all: 12),
                                                  );
                                                }).toList()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Semantics(
                                      button: true,
                                      label:
                                          "Chercher les maisons selon ma position actuelle",
                                      onTap: () {
                                        tempType = selectedHouseType;
                                        setState(() {
                                          _isSearching = true;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 10, top: 5),
                                        decoration: BoxDecoration(
                                            color: AppColor.white,
                                            borderRadius:
                                                BorderRadius.circular(3.0)),
                                        child: IconButton(
                                          onPressed: () {
                                            tempType = selectedHouseType;
                                            setState(() {
                                              _isSearching = true;
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.search,
                                            color: AppColor.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Semantics(
                                  button: true,
                                  label: _isFullScreen
                                      ? "Réduire la carte"
                                      : "Agrandir la carte",
                                  onTap: () {
                                    setState(() {
                                      _isFullScreen = !_isFullScreen;
                                    });
                                  },
                                  tooltip: _isFullScreen
                                      ? "Réduire la carte"
                                      : "Agrandir la carte",
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, top: 10),
                                    decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius:
                                            BorderRadius.circular(3.0)),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isFullScreen = !_isFullScreen;
                                        });
                                      },
                                      icon: Icon(
                                        _isFullScreen
                                            ? Icons.fullscreen_exit
                                            : Icons.fullscreen,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Semantics(
                                  button: true,
                                  label:
                                      "Centrer la carte sur mes coordonnées actuelles",
                                  onTap: () async {
                                    isFirst=true;
                                    setState(() {
                                      _center = null;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius:
                                            BorderRadius.circular(3.0)),
                                    child: IconButton(
                                      onPressed: () async {
                                        isFirst=true;
                                        setState(() {
                                          _center = null;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.my_location,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 10, bottom: 10),
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Semantics(
                                        onTap: () {
                                          _zoom += .2;
                                          _mapController.move(_center!, _zoom);
                                        },
                                        button: true,
                                        label: "Zoomer la carte",
                                        child:  IconButton(
                                          onPressed: () {
                                            _zoom += .2;
                                            _mapController.move(_center!, _zoom);
                                          },
                                            icon: Icon(Icons.add),
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        width: 22,
                                        color: AppColor.placeholderGrey,
                                      ),
                                      Semantics(
                                        button: true,
                                        label: "Dézoomer la carte",
                                        onTap: () {
                                          _zoom -= .2;
                                          _mapController.move(_center!, _zoom);
                                        },
                                        child:  IconButton(
                                          onPressed: () {
                                            _zoom -= .2;
                                            _mapController.move(_center!, _zoom);
                                          },
                                            icon: Icon(Icons.remove),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.hostmi.props.search',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _center!,
                                width: 80,
                                height: 80,
                                builder: (BuildContext context) => const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                ),
                              ),
                              ..._points.map((house) {
                                return Marker(
                                  point:
                                      LatLng(house.latitude!, house.longitude!),
                                  width: 200,
                                  height: 80,
                                  builder: (BuildContext context) =>
                                      GestureDetector(
                                    onTap: () {
                                      _houseFuture = null;
                                      _scrollController.animateTo(.5,
                                          duration: 500.ms,
                                          curve: Curves.decelerate);
                                      _houseFuture = selectHouseByID(house.id!)
                                          .whenComplete(() {
                                        setState(() {});
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.house,
                                          color: AppColor.primary,
                                        ),
                                        Card(
                                          child: Text("${house.price} "),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
        _isSearching
            ? Positioned.fill(
                child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedHouseType = tempType;
                    _showResult = false;
                    _isSearching = false;
                  });
                },
                child: Container(
                  color: Colors.black.withOpacity(.2),
                  child: GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 30.0),
                          child: Form(
                            key: _formState,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Paramètrer la recherche",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtManropeExtraBold18Blue500
                                        .copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.2))),
                                Padding(
                                    padding: getPadding(top: 17),
                                    child: Text("Type de propriétés recherché",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeSemiBold14Gray900)),
                                CustomDropDown<HouseType>(
                                    value: HouseType(id: selectedHouseType),
                                    focusNode: FocusNode(),
                                    icon: Container(
                                        margin: getMargin(left: 30, right: 16),
                                        child: CustomImageView(
                                            svgPath: ImageConstant
                                                .imgArrowdownGray900)),
                                    hintText: "Choisir un type de maison",
                                    margin: getMargin(top: 12),
                                    variant: DropDownVariant.FillBluegray50,
                                    fontStyle: DropDownFontStyle
                                        .ManropeMedium14Bluegray500,
                                    items: [
                                      const DropdownMenuItem<HouseType>(
                                          value: HouseType(
                                              id: 0, fr: "Tout", en: "All"),
                                          child: Text(
                                            "Tout",
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                      ...context
                                          .watch<HostmiProvider>()
                                          .houseTypesList
                                          .map((houseType) {
                                        return DropdownMenuItem<HouseType>(
                                            value: HouseType.fromMap(
                                                data: houseType),
                                            child: Text(
                                              houseType["fr"].toString(),
                                              overflow: TextOverflow.ellipsis,
                                            ));
                                      }).toList()
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _showResult = false;
                                      });
                                      selectedHouseType = value.id;
                                    }),
                                Padding(
                                    padding: getPadding(top: 17),
                                    child: Text(
                                        "Distance de recherche en mètres",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeSemiBold14Gray900)),
                                CustomTextFormField(
                                  controller: _distanceController,
                                  textInputType: TextInputType.number,
                                  textInputAction: TextInputAction.search,
                                  onChanged: (value) {
                                    if (_showResult) {
                                      setState(() {
                                        _showResult = false;
                                      });
                                    }
                                  },
                                  validator: (value) {
                                    int distance = int.tryParse(
                                            _distanceController.text) ??
                                        -1;
                                    if (distance < 0) {
                                      return "Distance invalide !";
                                    } else if (distance < 500) {
                                      return "La distance minimum est de 500m";
                                    } else if (distance > 30000) {
                                      return "La distance maximum est de 30000m";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                DefaultAppButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _showResult
                                          ? showResults
                                          : _getHouses,
                                  text: _isLoading
                                      ? 'Recherche en cours...'
                                      : _showResult
                                          ? "Voir $_lastSearchLength résultat(s)"
                                          : "Rechercher",
                                ),
                              ],
                            ),
                          ),
                        )),
                      ),
                    ),
                  ),
                ),
              ))
            : const SizedBox(),
        DraggableScrollableSheet(
          controller: _scrollController,
          minChildSize: 0.0,
          initialChildSize: 0.0,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              decoration: const BoxDecoration(
                color: AppColor.grey,
              ),
              child: Scrollbar(
                  child: ListView(
                controller: scrollController,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: SizedBox()),
                      Container(
                        height: 5.0,
                        width: 30,
                        margin: const EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: Colors.grey[300],
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  FutureBuilder<DatabaseResponse>(
                      future: _houseFuture,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isSuccess) {
                            HouseModel model =
                                HouseModel.fromMap(snapshot.data!.list![0]);
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                HouseCard(house: model),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Gallerie"),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(children: [
                                    ...model.imagesUrl!
                                        .map((e) => Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: SizedBox(
                                                  height: getVerticalSize(130),
                                                  width: getHorizontalSize(100),
                                                  child: CachedNetworkImage(
                                                      fit: BoxFit.fitHeight,
                                                      imageUrl: supabase.storage
                                                          .from("agencies")
                                                          .getPublicUrl(e[
                                                                  "image_url"]
                                                              .toString()
                                                              .replaceFirst(
                                                                  "agencies/",
                                                                  ""))),
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ]),
                                ),
                                Padding(
                                  padding: getPadding(top: 8.0, bottom: 8.0),
                                  child: DefaultAppButton(
                                    onPressed: () {
                                      context.push(
                                          "/property-details/${model.id}");
                                    },
                                    text: "Je veux en savoir plus",
                                  ),
                                ),
                              ],
                            );
                          }
                        }
                        return const HouseCardShimmer();
                      }),
                ],
              )),
            );
          },
        )
      ],
    );
  }

  Future<void> _getHouses() async {
    bool isConnected = await checkInternetStatus();
    if (isConnected) {
      if (_formState.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        double distance = double.parse(_distanceController.text);
        response = selectedHouseType == 0
            ? await getAllNearbyHouses(
                _center!,
                double.tryParse(_distanceController.text) ?? 30000,
              )
            : await getNearbyHouses(_center!, distance, selectedHouseType);
        debugPrint("Id de le maison: $selectedHouseType");
        if (response.isSuccess) {
          setState(() {
            _lastSearchLength = response.list!.length;
            _showResult = true;
            _isLoading = false;
          });
        }
      }
    } else {
      Fluttertoast.showToast(
          msg: "Vériifiez votre connexion internet...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void showResults() {
    setState(() {
      _isSearching = false;
      _showResult = false;
      // debugPrint(response.list.toString());

      _points = response.list!.map((e) {
        HouseModel model = HouseModel(
          id: e["id"],
          agencyId: e["agency_id"],
          latitude: double.tryParse(e["latitude"].toString()) ?? 0,
          longitude: double.tryParse(e["longitude"].toString()) ?? 0,
          price: double.tryParse("${e["price"]}"),
        );
        return model;
      }).toList();
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
