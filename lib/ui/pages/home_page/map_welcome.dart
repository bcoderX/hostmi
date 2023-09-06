import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/ui/pages/ball_loading_page.dart';
import 'package:hostmi/ui/pages/home_page/map_search_delegate.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
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
  final List<LatLng> _points = [];
  LatLng? _center;
  final bool _isDrawable = false;
  final CitySearchDelegate _delegate =
      CitySearchDelegate(["Koudougou", "Bobo Dioulasso", "Ouagadougou"]);
  double _zoom = 10.2;
  @override
  void initState() {
    //_chek();
    super.initState();
  }

  void _chek() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        setState(() {
          _center=LatLng(12.253609, -2.378845);
        });
      }
      else if(permission == LocationPermission.deniedForever){
        setState(() {
          _center=LatLng(12.253609, -2.378845);
        });

      }
      else{
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _center = LatLng(position.latitude, position.longitude);
          _mapController.move(_center!, _zoom);
        });
      }
    }
    else{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if(_center==null){
      _chek();
      setState(() {
      });
      return const BallLoadingPage();
    }
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: BoxConstraints(
            minHeight: screenSize.height,
          ),
          child: Column(
            children: [
              Container(
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
                      vertical: 25.0, horizontal: 25),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.welcome,
                        style: const TextStyle(
                          color: AppColor.grey,
                          fontFamily: 'Roboto',
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.welcomeSlogan,
                        style: const TextStyle(
                          color: AppColor.grey,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                        child: ListTile(
                          onTap: () async {
                            final String? selected = await showSearch<String>(
                              context: context,
                              delegate: _delegate,
                            );
                            if (selected != null) {}
                          },
                          style: ListTileStyle.list,
                          leading: const Icon(Icons.search),
                          title: Text(
                            AppLocalizations.of(context)!.searchCityPlaceholder,
                            style: const TextStyle(
                                color: AppColor.placeholderGrey),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 1.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text("HostMi"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: FlutterMap(
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
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10, top: 10),
                      decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(3.0)),
                      child: IconButton(
                        onPressed: () {},
                        tooltip: "Dessiner",
                        icon: const Icon(
                          Icons.edit,
                          color: AppColor.primary,
                        ),
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
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: _points,
                        color: AppColor.primary,
                        isDotted: false,
                        isFilled: true,
                      ),
                    ],
                  )
                ],
              )
                  /*GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(12.253609, -2.378845), zoom: 1.0),
                  ),*/
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
