import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/screens/login_screen.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
      context.read<HostmiProvider>().getHouseTypes();
      context.read<HostmiProvider>().getHouseCategories();
      context.read<HostmiProvider>().getCurrencies();
    });
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
          child: Row(
            children: [
              Text(
                "${context.watch<HostmiProvider>().houseForm.houseType?.fr ?? '--'} - "
                    .toUpperCase(),
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
                  context.watch<HostmiProvider>().houseForm.houseCategory?.fr ??
                      '--',
                ),
              ),
            ],
          ),
        ),
        Material(
          borderRadius: BorderRadius.circular(5.0),
          elevation: 1.0,
          child: Stack(children: [
            const SizedBox(
              height: 3,
            ),
            AspectRatio(
              aspectRatio: 400 / 350,
              child: Container(
                height: getVerticalSize(350),
                constraints: BoxConstraints(maxWidth: getHorizontalSize(400)),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(5.0),
                  image: DecorationImage(
                    image: house.mainImage! == null
                        ? const AssetImage("assets/images/image_not_found.png")
                        : FileImage(house.mainImage!) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
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
                          Text(
                            "${house.price} ${context.watch<HostmiProvider>().houseForm.currency?.currency ?? '--'} ${context.watch<HostmiProvider>().houseForm.priceType?.fr ?? '--'}",
                            style: const TextStyle(
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
                            "${house.beds} chambres ${house.bathrooms} douches",
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
                      _spacer,
                      Text(
                        "${house.fullAddress}",
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
                              "Publiée le ${DateFormat.yMMMEd("fr").format(date)}",
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
