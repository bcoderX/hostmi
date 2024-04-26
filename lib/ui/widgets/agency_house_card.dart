import 'package:cached_network_image/cached_network_image.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/supabase/rest/houses/update_availability.dart';
import 'package:hostmi/api/supabase/supabase_client.dart';
import 'package:hostmi/api/utils/check_internet_status.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/screens/agency_screen/widgets/modify_house_coords.dart';
import 'package:hostmi/ui/screens/product_details_screen/product_details_screen.dart';
import 'package:hostmi/ui/widgets/custom_context_menu_region.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:hostmi/widgets/custom_switch.dart';
import 'package:intl/intl.dart' as intl;
import 'package:numeral/numeral.dart';
import 'package:share_plus/share_plus.dart';

class AgencyHouseCard extends StatefulWidget {
  const AgencyHouseCard({Key? key, required this.house, this.onDelete})
      : super(key: key);
  final HouseModel house;
  final void Function()? onDelete;
  @override
  State<AgencyHouseCard> createState() => _AgencyHouseCardState();
}

class _AgencyHouseCardState extends State<AgencyHouseCard> {
  late Future<int> _viewCountFuture;
  late bool isSelectedSwitch;

  @override
  void initState() {
    isSelectedSwitch = widget.house.isAvailable!;
    _viewCountFuture = getViewCount(widget.house.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: 1.0,
          color: AppColor.white,
          child: Stack(children: [
            GestureDetector(
              onTap: () async {
                context.push("/property-details/${widget.house.id}");
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
          ]),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                            text:
                                "${widget.house.houseType!.fr}\n".toUpperCase(),
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
                    CustomSwitch(
                        value: isSelectedSwitch,
                        onChanged: (value) async {
                          bool hasInternet = await checkInternetStatus();
                          if (hasInternet) {
                            Fluttertoast.showToast(
                              msg: "Veuillez patienter...",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                         bool res =   await toggleHouseAvailability(
                                widget.house.id!, value);
                         if(res){
                           Fluttertoast.showToast(
                             msg: "Opération réussie...",
                             toastLength: Toast.LENGTH_SHORT,
                             gravity: ToastGravity.BOTTOM,
                             timeInSecForIosWeb: 1,
                             backgroundColor: Colors.grey,
                             textColor: Colors.white,
                             fontSize: 16.0,
                           );
                         }
                            setState(() {
                              isSelectedSwitch = value;
                            });
                          }else{
                            Fluttertoast.showToast(
                              msg: "Vérifiez votre connexion...",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        }),
                    CustomContextMenuRegion(
                        contextMenu: GenericContextMenu(
                          injectDividers: true,
                          buttonConfigs: [
                            ContextMenuButtonConfig(
                              "Supprimer",
                              onPressed: widget.onDelete,
                            ),
                            ContextMenuButtonConfig(
                              "Modifier les coordonnées GPS",
                              onPressed: () {
                                _showEditCoordsDialog();
                              },
                            ),
                          ],
                        ),
                        child: Semantics(
                          label: "Options de la maison",
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 3,
                                  backgroundColor: Colors.grey[700],
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                CircleAvatar(
                                  radius: 3,
                                  backgroundColor: Colors.grey[700],
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                CircleAvatar(
                                  radius: 3,
                                  backgroundColor: Colors.grey[700],
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
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
                      "${widget.house.beds} chambres ${widget.house.bathrooms} douches",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColor.black,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                widget.house.fullAddress!.isEmpty
                    ? "${widget.house.sector == 0 ? "" : "Secteur ${widget.house.sector},"} ${widget.house.city}, ${widget.house.country!.fr}"
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
                      "Publiée le ${intl.DateFormat.yMMMEd("fr").format(widget.house.createdAt!)}",
                      style: const TextStyle(
                        color: AppColor.primary,
                        fontSize: 14.0,
                      ),
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
              Row(
                children: [
                  const Text(
                    "STATUT: ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                  Expanded(
                      child: Text(
                    widget.house.isUnderVerification!
                        ? "EXAMEN EN COURS"
                        : widget.house.isAccepted!
                            ? "PUBLIÉE"
                            : "REJETÉE",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.house.isUnderVerification!
                          ? Colors.orange
                          : widget.house.isAccepted!
                              ? Colors.green
                              : Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                  )),
                ],
              ),
              ExpansionTile(
                title: const Text(
                  "Détails",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                childrenPadding: const EdgeInsets.all(8.0),
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.house.isUnderVerification!
                          ? "Nous vérifions que la propriété que vous avez publiée est pertinent aux utilisateurs de notre application et respecte nos conditions d'utilisation. Cette opération pourrait durer en fonction du nombre de maison que nous devons valider avant."
                          : widget.house.isAccepted!
                              ? "Cette propriété est visible par tous les utilisateurs de l'application Hostmi."
                              : "Les raisons pouvant mener au refus de votre propriété pourraient être entre autres la présence de numéro de téléphone ou tout autre élément permettant de vous contacter directement sur vos images ou textes, des contenus n'ayant rien à voir avec une propriété à louer, la présence de la même propriété dans une autre agence, etc.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.justify,
                    ),
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

  Future<int> getViewCount(String houseId) async {
    final viewCount =
        await supabase.rpc("get_house_views", params: {"house_id": houseId});
    debugPrint(viewCount.toString());
    return viewCount;
  }

  _showEditCoordsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.10,
              ),
              AlertDialog(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Coordonnées GPS"),
                    Text("Permettre l'affichage de votre maison sur la carte",
                        style: AppStyle.txtManrope12),
                  ],
                ),
                content: ModifyHouseCoords(
                  houseId: widget.house.id!,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
