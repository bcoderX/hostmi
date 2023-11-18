import 'package:cached_network_image/cached_network_image.dart';
import 'package:hostmi/api/models/house_features.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/supabase/houses/select_features.dart';
import 'package:hostmi/api/supabase/houses/select_houses.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/generated/l10n.dart';
import 'package:hostmi/ui/screens/add_new_property_screens/add_new_property_select_amenities_screen/widgets/options_item_widget.dart';
import 'package:hostmi/ui/screens/agency_screen/agency_screen.dart';
import 'package:hostmi/ui/screens/ball_loading_page.dart';
import 'package:hostmi/ui/screens/chat_page.dart';
import 'package:hostmi/ui/screens/product_details_screen/widgets/features_list.dart';
import 'package:hostmi/widgets/reviews_list.dart';
import 'package:intl/intl.dart';
import '../product_details_screen/widgets/listfive_item_widget.dart';
import '../product_details_screen/widgets/listrectangle4224_item_widget.dart';
import '../product_details_screen/widgets/sliderarrowleft_item_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/widgets/custom_button.dart';
import 'package:hostmi/widgets/custom_icon_button.dart';
import 'package:hostmi/widgets/custom_radio_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.houseId});
  final String houseId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final MapController _mapController = MapController();
  final double _zoom = 10.2;
  int silderIndex = 1;
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0;
  double _scrollPosition = 0;
  String radioGroup = "";
  late Future<List<HouseModel>> _future;
  HouseModel? loadedHouse;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _future = getHouseDetails(widget.houseId);
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;
    return Scaffold(
        backgroundColor: ColorConstant.gray50,
        body: Scrollbar(
            child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: FutureBuilder<List<HouseModel>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return SizedBox(
                        height: screenSize.height,
                        width: screenSize.width,
                        child: const BallLoadingPage(
                          loadingTitle: "Chargement des caractéristiques...",
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Error: ${snapshot.error}"),
                          IconButton(
                              onPressed: () {
                                _future = getHouseDetails(widget.houseId);
                              },
                              icon: const Icon(
                                Icons.replay_circle_filled_rounded,
                                size: 40,
                                color: AppColor.primary,
                              ))
                        ],
                      ));
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text("Error"));
                    }

                    if (snapshot.data!.isEmpty) {
                      return SizedBox(
                        height: screenSize.height,
                        width: screenSize.width,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: getHorizontalSize(25)),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Erreur de chargement",
                                      style: TextStyle(
                                          fontSize: getFontSize(18),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                        "Nous n'arrivons pas à trouver la maison selectionnée. Vérifiez votre connexion internet et réessayez."),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          _future =
                                              getHouseDetails(widget.houseId);
                                        },
                                        child: const Text("Réessayer"))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    HouseModel house = loadedHouse = snapshot.data![0];
                    // print(house.latitude);
                    return Column(
                      children: [
                        SizedBox(
                            width: double.infinity,
                            child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  CarouselSlider.builder(
                                      options: CarouselOptions(
                                          height: getSize(343),
                                          initialPage: 0,
                                          autoPlay: true,
                                          viewportFraction: 1.0,
                                          enableInfiniteScroll: false,
                                          scrollDirection: Axis.horizontal,
                                          onPageChanged: (index, reason) {
                                            setState(() {
                                              silderIndex = index;
                                            });
                                          }),
                                      itemCount: house.imagesUrl!.length,
                                      itemBuilder: (context, index, realIndex) {
                                        return SliderarrowleftItemWidget(
                                          imageUrl: supabase.storage
                                              .from("agencies")
                                              .getPublicUrl(house
                                                  .imagesUrl![index]
                                                      ["image_url"]
                                                  .toString()
                                                  .replaceFirst(
                                                      "agencies/", "")),
                                        );
                                      }),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                          height: getVerticalSize(3),
                                          margin: getMargin(bottom: 16),
                                          child: AnimatedSmoothIndicator(
                                              activeIndex: silderIndex,
                                              count: house.imagesUrl!.length,
                                              axisDirection: Axis.horizontal,
                                              effect: ScrollingDotsEffect(
                                                  spacing: 4,
                                                  activeDotColor:
                                                      ColorConstant.brown500,
                                                  dotColor:
                                                      ColorConstant.gray30099,
                                                  dotHeight: getVerticalSize(3),
                                                  dotWidth:
                                                      getHorizontalSize(16)))))
                                ])),
                        Padding(
                            padding: getPadding(
                                left: 5, right: 5, top: 33, bottom: 5),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                      padding: getPadding(left: 8, top: 34),
                                      child: Text("Description",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeBold18
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  Padding(
                                      padding: getPadding(
                                          left: 8, top: 13, right: 39),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomIconButton(
                                                height: 34,
                                                width: 34,
                                                variant: IconButtonVariant
                                                    .FillBlue500,
                                                shape: IconButtonShape
                                                    .RoundedBorder5,
                                                child: CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgIcon20x20)),
                                            Padding(
                                                padding: getPadding(left: 2),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text("Chambre",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: AppStyle
                                                              .txtManrope10
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      getHorizontalSize(
                                                                          0.4))),
                                                      Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Padding(
                                                              padding:
                                                                  getPadding(
                                                                      top: 1),
                                                              child: Text(
                                                                  "${house.beds} pièce(s)",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: AppStyle
                                                                      .txtManropeBold12
                                                                      .copyWith(
                                                                          letterSpacing:
                                                                              getHorizontalSize(0.4)))))
                                                    ])),
                                            CustomIconButton(
                                                height: 34,
                                                width: 34,
                                                margin: getMargin(left: 5),
                                                variant: IconButtonVariant
                                                    .FillBlue500,
                                                shape: IconButtonShape
                                                    .RoundedBorder5,
                                                child: CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgLock20x20)),
                                            Padding(
                                                padding: getPadding(left: 1),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text("Douche",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: AppStyle
                                                              .txtManrope10
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      getHorizontalSize(
                                                                          0.4))),
                                                      Padding(
                                                          padding: getPadding(
                                                              top: 1),
                                                          child: Text(
                                                              "${house.bathrooms} pièces",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: AppStyle
                                                                  .txtManropeBold12
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                              0.4))))
                                                    ])),
                                            CustomIconButton(
                                                height: 34,
                                                width: 34,
                                                margin: getMargin(left: 5),
                                                variant: IconButtonVariant
                                                    .FillBlue500,
                                                shape: IconButtonShape
                                                    .RoundedBorder5,
                                                child: CustomImageView(
                                                    svgPath: ImageConstant
                                                        .imgOffer20x20)),
                                            Padding(
                                                padding:
                                                    getPadding(left: 8, top: 2),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text("Superficie",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: AppStyle
                                                              .txtManrope10
                                                              .copyWith(
                                                                  letterSpacing:
                                                                      getHorizontalSize(
                                                                          0.4))),
                                                      Padding(
                                                          padding: getPadding(
                                                              top: 1),
                                                          child: Text("---",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: AppStyle
                                                                  .txtManropeBold12
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          getHorizontalSize(
                                                                              0.4))))
                                                    ]))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 31),
                                      child: Text("A propos",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeBold18
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  Container(
                                      width: getHorizontalSize(327),
                                      margin: getMargin(
                                          left: 8, top: 13, right: 39),
                                      child: Text("${house.description}",
                                          maxLines: null,
                                          textAlign: TextAlign.justify,
                                          style: AppStyle
                                              .txtManropeRegular14Gray900)),
                                  Padding(
                                      padding: getPadding(left: 8, top: 13),
                                      child: Row(children: [
                                        Text("Voir plus",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeBold14Blue500
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2))),
                                        CustomImageView(
                                            svgPath: ImageConstant
                                                .imgArrowright16x16,
                                            height: getSize(16),
                                            width: getSize(16),
                                            margin: getMargin(
                                                left: 8, top: 1, bottom: 2))
                                      ])),
                                  Padding(
                                      padding: getPadding(
                                          left: 8, top: 34, bottom: 13),
                                      child: Text("Galerie",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeBold18
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(children: [
                                      ...house.imagesUrl!
                                          .map((e) => Container(
                                                height: getVerticalSize(130),
                                                width: getHorizontalSize(100),
                                                margin: getMargin(left: 14),
                                                child: CachedNetworkImage(
                                                    fit: BoxFit.fitHeight,
                                                    imageUrl: supabase.storage
                                                        .from("agencies")
                                                        .getPublicUrl(
                                                            e["image_url"]
                                                                .toString()
                                                                .replaceFirst(
                                                                    "agencies/",
                                                                    ""))),
                                              ))
                                          .toList(),
                                    ]),
                                  ),
                                  Padding(
                                      padding: getPadding(left: 8, top: 32),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Position sur la carte",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle.txtManropeBold18
                                                  .copyWith(
                                                      letterSpacing:
                                                          getHorizontalSize(
                                                              0.2))),
                                          Text(
                                              "Ceci est juste une position aproximative. Veuillez contactez l'agence pour en savoir plus.",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: getFontSize(15),
                                                  color:
                                                      AppColor.listItemGrey)),
                                        ],
                                      )),
                                  Container(
                                    height: getVerticalSize(152),
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    child: FlutterMap(
                                      mapController: _mapController,
                                      options: MapOptions(
                                        center: house.latitude == 0 &&
                                                house.longitude == 0
                                            ? null
                                            : LatLng(house.latitude!,
                                                house.longitude!),
                                        zoom: _zoom,
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate:
                                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                          userAgentPackageName:
                                              'com.example.hostmi',
                                        ),
                                        MarkerLayer(
                                          markers: house.latitude == 0 &&
                                                  house.longitude == 0
                                              ? []
                                              : [
                                                  Marker(
                                                    point: LatLng(
                                                        house.latitude!,
                                                        house.longitude!),
                                                    width: 80,
                                                    height: 80,
                                                    builder: (BuildContext
                                                            context) =>
                                                        CircleAvatar(
                                                      radius: 50,
                                                      backgroundColor: AppColor
                                                          .primary
                                                          .withOpacity(.2),
                                                      child: const Icon(
                                                        Icons.house,
                                                        color: AppColor.primary,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(
                                      top: 34,
                                    ),
                                    child: Row(
                                      children: [
                                        Text("Détails clés",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtManropeBold18
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2))),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(left: 8, top: 21),
                                    child: Text(
                                      "Détails de prix",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtManropeBold16.copyWith(
                                          letterSpacing:
                                              getHorizontalSize(0.2)),
                                    ),
                                  ),
                                  Padding(
                                    padding: getPadding(left: 8, top: 11),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Prix",
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.left,
                                              style: AppStyle
                                                  .txtManropeRegular14Gray900),
                                          Padding(
                                              padding: getPadding(left: 200),
                                              child: Text(
                                                  loadedHouse!.formattedPrice,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtManropeSemiBold14Gray900))
                                        ]),
                                  ),
                                  Padding(
                                    padding: getPadding(left: 8, top: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Padding(
                                              padding: getPadding(top: 1),
                                              child: Text(
                                                  "Fréquence de paiement",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.left,
                                                  style: AppStyle
                                                      .txtManropeRegular14Gray900)),
                                        ),
                                        Text("${loadedHouse!.priceType!.fr}",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeSemiBold14Gray900)
                                      ],
                                    ),
                                  ),
                                  Padding(
                                      padding: getPadding(left: 8, top: 19),
                                      child: Text("Faits sur la maison",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeBold16
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  Padding(
                                      padding: getPadding(
                                        left: 8,
                                        top: 13,
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                  padding:
                                                      getPadding(bottom: 1),
                                                  child: Text("Sur le marché",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtManropeRegular14Gray900)),
                                            ),
                                            Padding(
                                                padding: getPadding(top: 1),
                                                child: Text(
                                                    DateFormat.yMMMEd("fr")
                                                        .format(
                                                            house.createdAt!),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 11),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding: getPadding(top: 1),
                                                child: Text("Pays",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeRegular14Gray900)),
                                            Padding(
                                                padding: getPadding(
                                                    left: 140, bottom: 1),
                                                child: Text(
                                                    "${house.country!.fr}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 11),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding: getPadding(top: 1),
                                                child: Text("Ville",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeRegular14Gray900)),
                                            Padding(
                                                padding: getPadding(
                                                    left: 160, bottom: 1),
                                                child: Text("${house.city}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 11),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Quartier",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtManropeRegular14Gray900),
                                            Padding(
                                                padding: getPadding(left: 180),
                                                child: Text("${house.quarter}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 12),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Secteur",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtManropeRegular14Gray900),
                                            Padding(
                                                padding: getPadding(left: 240),
                                                child: Text(
                                                    "${house.sector == 0 ? "---" : house.sector}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 13),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                  padding:
                                                      getPadding(bottom: 1),
                                                  child: Text(
                                                      "Adresse complète",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                      style: AppStyle
                                                          .txtManropeRegular14Gray900)),
                                            ),
                                            Padding(
                                                padding: getPadding(top: 1),
                                                child: Text(
                                                    house.fullAddress!.isEmpty
                                                        ? "${house.sector == 0 ? "" : "Secteur ${house.sector},"} ${house.city}, ${house.country!.fr}"
                                                        : house.fullAddress!,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeSemiBold14Gray900))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 15),
                                      child: Row(children: [
                                        Text("See More",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeBold14Blue500
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2))),
                                        CustomImageView(
                                            svgPath: ImageConstant
                                                .imgArrowright16x16,
                                            height: getSize(16),
                                            width: getSize(16),
                                            margin: getMargin(
                                                left: 8, top: 1, bottom: 2))
                                      ])),
                                  Padding(
                                      padding: getPadding(top: 24),
                                      child: Divider(
                                          height: getVerticalSize(1),
                                          thickness: getVerticalSize(1),
                                          color: ColorConstant.gray300,
                                          indent: getHorizontalSize(8),
                                          endIndent: getHorizontalSize(39))),
                                  Padding(
                                      padding: getPadding(left: 8, top: 25),
                                      child: Text("Catractéristiques",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style: AppStyle.txtManropeBold18
                                              .copyWith(
                                                  letterSpacing:
                                                      getHorizontalSize(0.2)))),
                                  FeaturesListWidget(
                                    featuresIDs: house.features!,
                                  ),
                                  Padding(
                                      padding: getPadding(left: 8, top: 15),
                                      child: Row(children: [
                                        Text("Toutes les caractéristiques",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeBold14Blue500
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2))),
                                        CustomImageView(
                                            svgPath: ImageConstant
                                                .imgArrowright16x16,
                                            height: getSize(16),
                                            width: getSize(16),
                                            margin: getMargin(
                                                left: 14, top: 1, bottom: 2))
                                      ])),
                                  Padding(
                                      padding: getPadding(top: 24),
                                      child: Divider(
                                          height: getVerticalSize(1),
                                          thickness: getVerticalSize(1),
                                          color: ColorConstant.gray300,
                                          indent: getHorizontalSize(8),
                                          endIndent: getHorizontalSize(39))),
                                  Padding(
                                      padding: getPadding(
                                        top: 23,
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Avis sur l'agence",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle.txtManropeBold18
                                                    .copyWith(
                                                        letterSpacing:
                                                            getHorizontalSize(
                                                                0.2))),
                                            Padding(
                                                padding: getPadding(
                                                    top: 4, bottom: 3),
                                                child: Text(
                                                    "Voir tous les avis",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                    style: AppStyle
                                                        .txtManropeBold12Blue500
                                                        .copyWith(
                                                            letterSpacing:
                                                                getHorizontalSize(
                                                                    0.4))))
                                          ])),
                                  Padding(
                                      padding: getPadding(left: 8, top: 14),
                                      child: Row(children: [
                                        Text("4.9",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle.txtManropeBold32
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2))),
                                        CustomImageView(
                                            svgPath: ImageConstant.imgTicket,
                                            height: getVerticalSize(15),
                                            width: getHorizontalSize(96),
                                            margin: getMargin(
                                                left: 12, top: 13, bottom: 14)),
                                        Padding(
                                            padding: getPadding(
                                                left: 14, top: 15, bottom: 11),
                                            child: Text("100 avis",
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.left,
                                                style: AppStyle
                                                    .txtManropeMedium12Gray900
                                                    .copyWith(
                                                        letterSpacing:
                                                            getHorizontalSize(
                                                                0.4))))
                                      ])),
                                  Padding(
                                      padding: getPadding(top: 24),
                                      child: Divider(
                                          height: getVerticalSize(1),
                                          thickness: getVerticalSize(1),
                                          color: ColorConstant.gray300,
                                          indent: getHorizontalSize(8),
                                          endIndent: getHorizontalSize(39))),
                                  ReviewList(agencyId: house.agencyId!),
                                  Padding(
                                      padding: getPadding(left: 8, top: 16),
                                      child: Row(children: [
                                        Text("Voir plus",
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: AppStyle
                                                .txtManropeBold14Blue500
                                                .copyWith(
                                                    letterSpacing:
                                                        getHorizontalSize(
                                                            0.2))),
                                        CustomImageView(
                                            svgPath: ImageConstant
                                                .imgArrowright16x16,
                                            height: getSize(16),
                                            width: getSize(16),
                                            margin: getMargin(
                                                left: 8, top: 1, bottom: 2))
                                      ])),
                                ])),
                      ],
                    );
                  }),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                backgroundColor: ColorConstant.gray50.withOpacity(_opacity),
                foregroundColor: AppColor.black,
                elevation: 0.0,
                title: const Text("Détails"),
              ),
            ),
          ],
        )),
        bottomNavigationBar: loadedHouse == null
            ? null
            : Container(
                padding: getPadding(left: 24, top: 13, right: 24, bottom: 13),
                decoration: AppDecoration.outlineBluegray1000f,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: getPadding(top: 2),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: getPadding(top: 4, bottom: 3),
                                    child: Text("Prix:",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtManropeMedium14Gray900)),
                                Text(
                                    "${loadedHouse!.formattedPrice} ${loadedHouse!.priceType!.fr}",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtManropeExtraBold20Blue500
                                        .copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.2)))
                              ])),
                      Padding(
                          padding: getPadding(top: 15),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomIconButton(
                                    height: 44,
                                    width: 44,
                                    margin: getMargin(top: 2, bottom: 2),
                                    variant:
                                        IconButtonVariant.OutlineBluegray50_1,
                                    padding: IconButtonPadding.PaddingAll12,
                                    child: CustomImageView(
                                        svgPath: ImageConstant.imgFavorite)),
                                CustomIconButton(
                                    height: 44,
                                    width: 44,
                                    margin: getMargin(top: 2, bottom: 2),
                                    variant:
                                        IconButtonVariant.OutlineBluegray50_1,
                                    padding: IconButtonPadding.PaddingAll12,
                                    child: CustomImageView(
                                        svgPath: ImageConstant.imgMail)),
                                CustomIconButton(
                                    height: 44,
                                    width: 44,
                                    margin: getMargin(top: 2, bottom: 2),
                                    variant:
                                        IconButtonVariant.OutlineBluegray50_1,
                                    padding: IconButtonPadding.PaddingAll12,
                                    child: const Icon(
                                      Icons.call,
                                      color: AppColor.primary,
                                      size: 15,
                                    )),
                                const Expanded(child: SizedBox()),
                                CustomButton(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => AgencyScreen(
                                            id: loadedHouse!.agencyId!),
                                      ));
                                    },
                                    height: getVerticalSize(48),
                                    width: double.infinity,
                                    text: "Voir l'agence",
                                    shape: ButtonShape.RoundedBorder5,
                                    padding: ButtonPadding.PaddingAll13,
                                    fontStyle: ButtonFontStyle
                                        .ManropeBold16WhiteA700_1),
                              ]))
                    ])));
  }

  Future<List<HouseModel>> getHouseDetails(String id) async {
    final housesList = await selectHouseByID(id);
    return housesList.map((e) => HouseModel.fromMap(e)).toList();
    // setState(() {});
  }
}
