import 'package:flutter/material.dart';
import 'package:hostmi/ui/pages/filter_page.dart';
import 'package:hostmi/ui/pages/home_page/map_search_delegate.dart';
import 'package:hostmi/ui/pages/home_page/map_welcome.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hostmi/ui/widgets/filter_button.dart';
import 'package:hostmi/ui/widgets/rounded_text_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final SizedBox _spacer = const SizedBox(height: 20);
  final MapController _mapController = MapController();
  List<LatLng> _points = [];
  bool _isDrawable = false;
  CitySearchDelegate _delegate =
  CitySearchDelegate(["Koudougou", "Bobo Dioulasso", "Ouagadougou"]);
  double _zoom = 9.2;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
              center: LatLng(12.253609, -2.378845),
              zoom: _zoom,
              onMapReady: () {
                _mapController.mapEventStream.listen((event) {
                  setState(() {
                    _zoom = event.zoom;
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
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  SizedBox(height: 70,),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RoundedTextField(
                          errorText: "Une erreur s'est produite",
                          placeholder: AppLocalizations.of(context)!.searchCityPlaceholder,
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: Align(
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
                        _spacer,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:  [
                            FilterButton(
                              onTap: (){
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                  return const FilterPage();
                                }));
                              },
                            ),
                            Container(
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.only(right: 10, bottom: 10),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _zoom += 2;
                        });
                      },
                      icon: Icon(Icons.add),
                    ),
                    Container(
                      height: 1,
                      width: 22,
                      color: AppColor.placeholderGrey,
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _zoom -= 2;
                        });
                      },
                      icon: Icon(Icons.remove),
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
        ),


      ],
    );
  }
}
