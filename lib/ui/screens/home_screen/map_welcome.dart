import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/ui/screens/ball_loading_page.dart';
import 'package:hostmi/ui/screens/home_screen/map_search_delegate.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hostmi/ui/widgets/rounded_text_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWelcome extends StatefulWidget {
  const MapWelcome({Key? key}) : super(key: key);

  @override
  State<MapWelcome> createState() => _MapWelcomeState();
}

class _MapWelcomeState extends State<MapWelcome> {
  final MapController _mapController = MapController();
  final List<LatLng> _points = [
    LatLng(12.253609, -2.378845),
    LatLng(12.253609, -2.378845),
    LatLng(12.253609, -2.378845)
  ];
  LatLng? _center;
  bool _isFullScreen = false;
  final bool _isDrawable = false;
  final CitySearchDelegate _delegate =
      CitySearchDelegate(["Koudougou", "Bobo Dioulasso", "Ouagadougou"]);
  double _zoom = 10.2;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    //_chek();
    super.initState();
  }

  void _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _center = LatLng(12.253609, -2.378845);
        });
      } else if (permission == LocationPermission.deniedForever) {
        setState(() {
          _center = LatLng(12.253609, -2.378845);
        });
      } else {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _center = LatLng(position.latitude, position.longitude);
          //_mapController.move(_center, _zoom);
        });
      }
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (_center == null) {
        _getLocation();
      }
    });

    return Container(
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
                        RoundedTextField(
                          isReadOnly: true,
                          onTap: () {
                            context.go("/map/search-place");
                          },
                          errorText: "errorText",
                          placeholder: "Chercher un lieu",
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: ElevatedButton(
                            onPressed: () {},
                            child: const Text("HostMi"),
                          ),
                        ),
                        // ListTile(
                        //   onTap: () async {
                        //     context.go("/map/search-place");
                        //   },
                        //   style: ListTileStyle.list,
                        //   leading: const Icon(Icons.search),
                        //   title: Text(
                        //     AppLocalizations.of(context)!.searchCityPlaceholder,
                        //     style:
                        //         const TextStyle(color: AppColor.placeholderGrey),
                        //   ),
                        //   trailing: ElevatedButton(
                        //     onPressed: () {},
                        //     child: const Text("HostMi"),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
          Expanded(
            child: _center == null
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
                        onTap: (TapPosition p, LatLng lt) {
                          if (_isDrawable) {
                            setState(() {
                              _points.add(lt);
                            });
                          }
                        }),
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
                        child: _isFullScreen
                            ? SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RoundedTextField(
                                    isReadOnly: true,
                                    onTap: () {
                                      context.go("/map/search-place");
                                    },
                                    errorText: "errorText",
                                    placeholder: "Chercher un lieu",
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: ElevatedButton(
                                      onPressed: () {},
                                      child: const Text("HostMI"),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),
                      SafeArea(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    right: 10, top: _isFullScreen ? 70 : 10),
                                decoration: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(3.0)),
                                child: IconButton(
                                  onPressed: () {},
                                  tooltip:
                                      "Chercher les maisons selon ma position actuelle",
                                  icon: const Icon(
                                    Icons.search,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 10, top: 10),
                                decoration: BoxDecoration(
                                    color: AppColor.white,
                                    borderRadius: BorderRadius.circular(3.0)),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isFullScreen = !_isFullScreen;
                                    });
                                  },
                                  tooltip:
                                      "Chercher les maisons selon ma position actuelle",
                                  icon: Icon(
                                    _isFullScreen
                                        ? Icons.fullscreen_exit
                                        : Icons.fullscreen,
                                    color: AppColor.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: const EdgeInsets.only(right: 10, bottom: 10),
                          color: Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _zoom += .2;
                                  _mapController.move(_center!, _zoom);
                                },
                                icon: const Icon(Icons.add),
                              ),
                              Container(
                                height: 1,
                                width: 22,
                                color: AppColor.placeholderGrey,
                              ),
                              IconButton(
                                onPressed: () {
                                  _zoom -= .2;
                                  _mapController.move(_center!, _zoom);
                                },
                                icon: const Icon(Icons.remove),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.hostmi',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _center!,
                            width: 80,
                            height: 80,
                            builder: (BuildContext context) => const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.hiking,
                                  color: AppColor.primary,
                                ),
                                Card(
                                  color: AppColor.primary,
                                  child: Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Text(
                                      " Moi ",
                                      style: TextStyle(color: AppColor.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      // PolygonLayer(
                      //   polygons: [
                      //     Polygon(
                      //       points: _points,
                      //       color: AppColor.primary,
                      //       isDotted: false,
                      //       isFilled: true,
                      //     ),
                      //   ],
                      // )
                    ],
                  ),
            /*  GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _center!, zoom: _zoom),
              ), */
          ),
        ],
      ),
    );
  }
}
