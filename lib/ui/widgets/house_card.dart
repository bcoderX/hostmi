import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/core/app_export.dart';
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
  final SizedBox _spacer = const SizedBox(height: 5);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15.0),
      elevation: 1.0,
      color: AppColor.white,
      child: Stack(children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (BuildContext context) {
              return const ProductDetailsScreen();
            }));
          },
          child: CachedNetworkImage(
            imageUrl:
                "https://rwwurjrdtxmszqpwpocx.supabase.co/storage/v1/object/public/agencies/cover_placeholder.png",
            imageBuilder: (context, imageProvider) => Container(
              height: getVerticalSize(350),
              constraints: BoxConstraints(maxWidth: getHorizontalSize(400)),
              decoration: BoxDecoration(
                color: AppColor.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Positioned.fill(
            child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: AppColor.white.withOpacity(.7),
            child: Padding(
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
                          IconButton(
                            icon: const Icon(Icons.share),
                            color: AppColor.primary,
                            onPressed: () {
                              // Navigator.of(context, rootNavigator: true)
                              //     .pushReplacement(
                              //   MaterialPageRoute(
                              //     builder: (BuildContext context) {
                              //       return const LoginPage();
                              //     },
                              //   ),
                              // );
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
                        child: const Text(
                          "Publiée le 22 oct. 2023",
                          style: TextStyle(
                            color: AppColor.primary,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     AppLocalizations.of(context)!.virtualTour,
                      //     style: const TextStyle(
                      //       color: AppColor.primary,
                      //       fontSize: 14.0,
                      //     ),
                      //   ),
                      // ),
                      const Expanded(child: SizedBox()),
                      const Icon(Icons.remove_red_eye),
                      const SizedBox(width: 5),
                      const Text("2")
                    ],
                  )
                ],
              ),
            ),
          ),
        ))
      ]),
    );
  }
}
