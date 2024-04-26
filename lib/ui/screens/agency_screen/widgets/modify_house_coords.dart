import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hostmi/api/supabase/rest/houses/update_coords.dart';
import 'package:hostmi/api/utils/check_connection_and_do.dart';
import 'package:hostmi/core/utils/size_utils.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_text_form_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ModifyHouseCoords extends StatefulWidget {
  const ModifyHouseCoords({super.key, required this.houseId});
  final String houseId;

  @override
  State<ModifyHouseCoords> createState() => _ModifyHouseCoordsState();
}

class _ModifyHouseCoordsState extends State<ModifyHouseCoords> {
  final double _rate = 5;
  bool _isSaving = false;
  bool _isSaved = false;
  bool hasRecord = false;
  bool _isGettingPosition = false;
  final SizedBox _spacer = const SizedBox(height: 15);
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _isSaved
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent,
                    size: getSize(130),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Modification réussi !"),
                  )
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Longitude",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: AppColor.listItemGrey,
                      ),
                    ),
                  ),
                  CustomTextFormField(
                      //focusNode: FocusNode(),
                      controller: _longitudeController,
                      hintText: "0",
                      margin: getMargin(top: 12, bottom: 5),
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.number),
                  _spacer,
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Latitude",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: AppColor.listItemGrey,
                      ),
                    ),
                  ),
                  CustomTextFormField(
                    controller: _latitudeController,
                    hintText: "0",
                    margin: getMargin(top: 12, bottom: 5),
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.number,
                  ),
                  TextButton(
                    onPressed: _isGettingPosition
                        ? null
                        : () {
                            _checkPermission(context);
                          },
                    child: _isGettingPosition
                        ? const SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator())
                        : const Text(
                            "Cliquer ici pour utiliser les coordonnées actuelles du téléphone"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving
                          ? null
                          : () {
                              checkConnectionAndDo(() async {
                                // Navigator.of(context).pop();
                                setState(() {
                                  _isSaving = true;
                                });
                                bool response = await updateCoords(
                                    lat: double.tryParse(
                                            _latitudeController.text.trim()) ??
                                        0,
                                    long: double.tryParse(
                                            _longitudeController.text.trim()) ??
                                        0,
                                    houseId: widget.houseId);
                                if (response) {
                                  setState(() {
                                    _isSaved = true;
                                  });
                                } else {
                                  setState(() {
                                    _isSaving = false;
                                  });
                                }
                              });
                            },
                      child: _isSaving
                          ? LoadingAnimationWidget.threeArchedCircle(
                              color: AppColor.white,
                              size: getSize(25),
                            )
                          : const Text("Modifier"),
                    ),
                  ),
                ],
              ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.grey,
                  foregroundColor: Colors.black),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Fermer")),
        )
      ],
    );
  }

  void _checkPermission(BuildContext context) async {
    setState(() {
      _isGettingPosition = true;
    });
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      setState(() {
        _latitudeController.text = position.latitude.toString();
        _longitudeController.text = position.longitude.toString();
      });
    } else {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        try {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.bestForNavigation);
          _longitudeController.text = position.longitude.toString();
          _latitudeController.text = position.latitude.toString();
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        reAskPermission();
      }
    }

    setState(() {
      _isGettingPosition = false;
    });
  }

  reAskPermission() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Demande d'accès"),
            content: const Text(
                "Veuillez cliquer sur autoriser pour choisir la position actuelles"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Annuler"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _checkPermission(context);
                },
                child: const Text("D'accord"),
              ),
            ],
          );
        });
  }
}
