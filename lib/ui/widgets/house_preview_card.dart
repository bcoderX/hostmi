import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/utils/check_connection_and_do.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:provider/provider.dart';
import 'package:timeago_flutter/timeago_flutter.dart';

class HousePreviewCard extends StatefulWidget {
  const HousePreviewCard({Key? key, required this.house}) : super(key: key);
  final HouseModel house;

  @override
  State<HousePreviewCard> createState() => _HousePreviewCardState();
}

class _HousePreviewCardState extends State<HousePreviewCard> {
  final SizedBox _spacer = const SizedBox(height: 5);
  DateTime date = DateTime.now();
  late HouseModel house;

  @override
  void initState() {
    house = context.read<HostmiProvider>().houseForm;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      checkConnectionAndDo(() {
        context.read<HostmiProvider>().getHouseTypes();
        context.read<HostmiProvider>().getHouseCategories();
        context.read<HostmiProvider>().getCurrencies();
      });
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(children: [
            ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: getVerticalSize(200),
                    minWidth: getHorizontalSize(400)),
                child: Container(
                  height: getVerticalSize(350),
                  constraints: BoxConstraints(maxWidth: getHorizontalSize(400)),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: house.mainImage == null
                          ? const AssetImage(
                              "assets/images/image_not_found.png")
                          : FileImage(house.mainImage!) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            const Positioned.fill(
                child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: CircleAvatar(
                  backgroundColor: AppColor.grey,
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
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
                    ],
                  ),
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
                          onPressed: () {}),
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
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Agence: 5"),
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ],
                  )
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
                          "Publiée $value",
                          style: const TextStyle(
                            color: AppColor.primary,
                            fontSize: 14.0,
                          ),
                        );
                      },
                      date: DateTime.now(),
                      locale: "fr",
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  const Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 5),
                  const Text("0")
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
}
