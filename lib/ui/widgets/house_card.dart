import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/screens/house_details.dart';
import 'package:hostmi/ui/screens/login_screen.dart';
import 'package:hostmi/ui/screens/product_details_screen/product_details_screen.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart';

class HouseCard extends StatefulWidget {
  const HouseCard({Key? key, required this.house}) : super(key: key);
  final HouseModel house;

  @override
  State<HouseCard> createState() => _HouseCardState();
}

class _HouseCardState extends State<HouseCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 5),
          child: Row(
            children: [
              Text(
                "${widget.house.houseType!.fr} - ".toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "${widget.house.houseCategory!.fr}",
                ),
              ),
            ],
          ),
        ),
        Material(
          borderRadius: BorderRadius.circular(5.0),
          elevation: 1.0,
          color: AppColor.white,
          child: Stack(children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ProductDetailsScreen(
                    houseId: widget.house.id!,
                  );
                }));
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: getVerticalSize(350),
                    minWidth: getHorizontalSize(400)),
                child: widget.house.mainImageUrl == null
                    ? Container(
                        height: getVerticalSize(350),
                        width: getHorizontalSize(400),
                        decoration: BoxDecoration(
                          backgroundBlendMode: BlendMode.colorBurn,
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(5.0),
                          image: const DecorationImage(
                            image:
                                AssetImage("assets/images/image_not_found.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: supabase.storage
                            .from("agencies")
                            .getPublicUrl(widget.house.mainImageUrl!
                                .replaceFirst(RegExp(r"agencies/"), "")),
                        // "https://rwwurjrdtxmszqpwpocx.supabase.co/storage/v1/object/public/agencies/cover_placeholder.png",
                        imageBuilder: (context, imageProvider) => AspectRatio(
                          aspectRatio: 400 / 350,
                          child: Container(
                            height: getVerticalSize(350),
                            width: getHorizontalSize(400),
                            decoration: BoxDecoration(
                              // color: Colors.grey,
                              borderRadius: BorderRadius.circular(5.0),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        placeholder: (context, url) => const Center(
                            child: SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        )),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
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
                          Expanded(
                            child: Text(
                              // "${widget.house.price} ",
                              "${widget.house.formattedPrice} ${widget.house.priceType!.fr}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold,
                                color: AppColor.black,
                              ),
                              overflow: TextOverflow.ellipsis,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.house.beds} chambres ${widget.house.bathrooms} douches",
                            style: const TextStyle(
                              color: AppColor.black,
                            ),
                          ),
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Agence: 5"),
                              Icon(
                                Icons.star,
                                color: AppColor.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        widget.house.fullAddress!.isEmpty
                            ? "Secteur ${widget.house.sector}, ${widget.house.city}, ${widget.house.country!.fr}"
                            : widget.house.fullAddress!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColor.black,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Publiée le ${DateFormat.yMMMEd("fr").format(widget.house.createdAt!)}",
                              style: const TextStyle(
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
                          const Text("0")
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ))
          ]),
        ),
        SizedBox(height: getVerticalSize(10)),
        Container(
            width: double.infinity,
            height: getVerticalSize(30),
            color: Colors.grey[200]),
        SizedBox(height: getVerticalSize(10)),
      ],
    );
  }
}
