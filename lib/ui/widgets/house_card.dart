import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/rest/agencies/reviews/get_avg_rate.dart';
import 'package:hostmi/api/supabase/rest/houses/favorites/insert_favorite_house.dart';
import 'package:hostmi/api/supabase/rest/houses/views/insert_new_view.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/api/utils/check_internet_status.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/routes.dart';
import 'package:hostmi/ui/alerts/info_dialog.dart';
import 'package:hostmi/ui/screens/product_details_screen/product_details_screen.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:numeral/numeral.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class HouseCard extends StatefulWidget {
  const HouseCard({Key? key, required this.house}) : super(key: key);
  final HouseModel house;

  @override
  State<HouseCard> createState() => _HouseCardState();
}

class _HouseCardState extends State<HouseCard> {
  late Future<int> _viewCountFuture;
  late Future<bool> _favoriteFuture;
  late Future<List<dynamic>> _agencyFuture;

  bool isFav = false;

  @override
  void initState() {
    _viewCountFuture = getViewCount(widget.house.id!);
    _favoriteFuture = getFavoriteStatus(widget.house.id!);
    _agencyFuture = getAgencyAvgRate(widget.house.agencyId!);

    _favoriteFuture.then((value) {
      isFav = value;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(children: [
            GestureDetector(
              onTap: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return ProductDetailsScreen(houseId: widget.house.id!);
                }));
                bool isLoggedIn = context.read<HostmiProvider>().isLoggedIn;
                bool isConnected = await checkInternetStatus();
                if (isConnected) {
                  if (isLoggedIn) {
                    bool isAlreadyAdded = await selectViewsWithUser(
                      userId: supabase.auth.currentUser!.id,
                      houseId: widget.house.id!,
                    );
                    if (isAlreadyAdded) {
                      await supabase.rpc("increment_user_house_view", params: {
                        "user_id": supabase.auth.currentUser!.id,
                        "house_id": widget.house.id!
                      });
                    } else {
                      await insertNewView(
                        userId: supabase.auth.currentUser!.id,
                        houseId: widget.house.id!,
                      );
                    }
                  } else {
                    bool isAlreadyAdded = await selectViewsWithNullUser(
                        houseId: widget.house.id!);
                    if (isAlreadyAdded) {
                      await supabase.rpc("increment_house_view",
                          params: {"house_id": widget.house.id!});
                    } else {
                      await insertNewView(
                        userId: "",
                        houseId: widget.house.id!,
                      );
                    }
                  }
                }
              },
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: getVerticalSize(200),
                    minWidth: getHorizontalSize(400)),
                child: widget.house.mainImageUrl == null
                    ? Container(
                        height: getVerticalSize(200),
                        width: getHorizontalSize(400),
                        decoration: BoxDecoration(
                          backgroundBlendMode: BlendMode.colorBurn,
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(10.0),
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
                        imageBuilder: (context, imageProvider) => AspectRatio(
                          aspectRatio: 400 / 200,
                          child: Container(
                            height: getVerticalSize(200),
                            width: getHorizontalSize(400),
                            decoration: BoxDecoration(
                              // color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          color: Colors.grey,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
              ),
            ),
            Positioned.fill(
                child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: CircleAvatar(
                  backgroundColor: AppColor.grey,
                  child: IconButton(
                    icon: isFav
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ).animate(
                            onComplete: (controller) {
                              controller.repeat();
                            },
                          ).scale(
                            duration: 1.seconds,
                            begin: const Offset(1.5, 1.5),
                          )
                        : const Icon(Icons.favorite_outline,
                            color: Colors.grey),
                    onPressed: () async {
                      bool isLoggedIn = supabase.auth.currentUser != null;
                      bool isConnected = await checkInternetStatus();
                      if (isConnected) {
                        if (isLoggedIn) {
                          List<Map<String, dynamic>> isAlreadyAdded =
                              await selectFromFavorites(
                            userId: supabase.auth.currentUser!.id,
                            houseId: widget.house.id!,
                          );
                          if (isAlreadyAdded.isNotEmpty) {
                            await updateFavoriteHouse(
                              userId: supabase.auth.currentUser!.id,
                              houseId: widget.house.id!,
                              isFav: !isAlreadyAdded[0]["is_favorite"],
                            );
                            getFavoriteStatus(widget.house.id!).then((value) {
                              setState(() {
                                isFav = value;
                              });
                            });
                          } else {
                            await insertFavoriteHouse(
                              userId: supabase.auth.currentUser!.id,
                              houseId: widget.house.id!,
                            );
                            getFavoriteStatus(widget.house.id!).then((value) {
                              setState(() {
                                isFav = value;
                              });
                            });
                          }
                        } else {
                          _showInfoDialog(
                            title: "Connectez vous",
                            content:
                                "Vous devez vous connecter pour utiliser les favoris",
                            actionTitle: "Se connecter",
                            onClick: () {
                              context.push(keyLoginRoute);
                            },
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ))
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 8.0),
          child: Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                      text: "${widget.house.houseType!.fr}\n".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                      children: [
                        TextSpan(
                          text: "${widget.house.houseCategory!.fr}",
                          style: TextStyle(
                            fontSize: getFontSize(16),
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        )
                      ]),
                ),
              ),
            ],
          ),
        ),
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
                  Expanded(
                    child: Text(
                      // "${widget.house.price} ",
                      "${widget.house.formattedPrice} ${widget.house.priceType!.fr}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: AppColor.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.house.latitude == 0 || widget.house.longitude == 0
                          ? const SizedBox()
                          : const Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                      IconButton(
                          icon: const Icon(Icons.share),
                          color: Colors.grey,
                          onPressed: () {
                            Share.share(
                                "https://hostmi.vercel.app/property-details/${widget.house.id}");
                          }),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${widget.house.beds} chambre(s) ${widget.house.bathrooms} douche(s)",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColor.black,
                      ),
                    ),
                  ),
                  FutureBuilder<List<dynamic>>(
                    future: _agencyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        debugPrint(snapshot.error.toString());
                      }
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(snapshot.data!.first['is_agency']
                                ? 'Agence'
                                : 'Annonceur'),
                            if (snapshot.data!.first['is_agency'])
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                              ),
                            Text(": ${snapshot.data!.first['stars']}"),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ],
                        );
                      }
                      return const Text("--");
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    widget.house.fullAddress!.isEmpty
                        ? "${widget.house.sector == 0 ? "" : "Secteur ${widget.house.sector},"} ${widget.house.city}, ${widget.house.country!.fr}"
                        : widget.house.fullAddress!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Timeago(
                      builder: (context, value) {
                        return Text(
                          "Diponibilisée $value",
                          style: const TextStyle(
                            color: AppColor.primary,
                            fontSize: 14.0,
                          ),
                        );
                      },
                      date: widget.house.availableOn!,
                      locale: "fr",
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  const Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 5),
                  FutureBuilder(
                    future: _viewCountFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        debugPrint(snapshot.error.toString());
                      }
                      if (snapshot.hasData) {
                        return Text(
                            int.parse(snapshot.data.toString()).numeral());
                      }
                      return const Text("--");
                    },
                  )
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: getVerticalSize(10)),
        Container(
            width: double.infinity,
            height: getVerticalSize(30),
            color: AppColor.white),
        SizedBox(height: getVerticalSize(10)),
      ],
    );
  }

  _showInfoDialog({
    required String title,
    required String content,
    required String actionTitle,
    void Function()? onClick,
  }) {
    showInfoDialog(
      title: title,
      content: content,
      actionTitle: actionTitle,
      context: context,
      onClick: onClick,
    );
  }

  Future<int> getViewCount(String houseId) async {
    try{
      final viewCount =
      await supabase.rpc("get_house_views", params: {"house_id": houseId});
      return viewCount;
    }
    catch(e){
      // debugPrint(viewCount.toString());
    }

    return 0;
  }

  Future<bool> getFavoriteStatus(String houseId) async {
    if (supabase.auth.currentUser != null) {
      final isFav = await isFavorite(
          userId: supabase.auth.currentUser!.id, houseId: houseId);

      debugPrint(isFav.toString());
      return isFav;
    }
    return false;
  }
}
