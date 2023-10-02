import 'package:flutter/material.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/ui/screens/ball_loading_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hostmi/ui/screens/house_details.dart';
import 'package:hostmi/ui/screens/login_screen.dart';
import 'package:hostmi/ui/screens/product_details_screen/product_details_screen.dart';
import 'package:hostmi/utils/app_color.dart';

class HouseCard extends StatefulWidget {
  const HouseCard({Key? key, required this.house}) : super(key: key);
  final HouseModel house;

  @override
  State<HouseCard> createState() => _HouseCardState();
}

class _HouseCardState extends State<HouseCard> {
  final SizedBox _spacer = const SizedBox(height: 10);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      elevation: 1.0,
      color: AppColor.white,
      child: Column(children: [
        Column(mainAxisSize: MainAxisSize.min, children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const ProductDetailsScreen();
              }));
            },
            child: Container(
              height: 150,
              decoration: const BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image: AssetImage("assets/images/4.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          _spacer,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "40 000 FCFA",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppColor.primary,
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite_outline),
                          color: AppColor.primary,
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return const LoginPage();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                _spacer,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "2 ${AppLocalizations.of(context)!.bedsAbbreviation} 2 ${AppLocalizations.of(context)!.bathRoomsAbbreviation}",
                      style: const TextStyle(
                        color: AppColor.black,
                      ),
                    ),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          color: AppColor.primary,
                        ),
                        Icon(
                          Icons.star,
                          color: AppColor.primary,
                        ),
                        Icon(
                          Icons.star,
                          color: AppColor.primary,
                        ),
                        Icon(
                          Icons.star,
                          color: AppColor.primary,
                        ),
                        Icon(
                          Icons.star,
                          color: AppColor.primary,
                        ),
                      ],
                    ),
                  ],
                ),
                _spacer,
                Text(
                  "${AppLocalizations.of(context)!.sector} 8, Koudougou, Burkina Faso",
                  style: const TextStyle(
                    color: AppColor.black,
                  ),
                ),
                _spacer,
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context)!.share,
                        style: const TextStyle(
                          color: AppColor.primary,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context)!.virtualTour,
                        style: const TextStyle(
                          color: AppColor.primary,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    const Icon(Icons.keyboard_arrow_down,
                        color: AppColor.primary)
                  ],
                )
              ],
            ),
          ),
        ]),
      ]),
    );
  }
}
