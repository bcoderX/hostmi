import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/supabase/rest/houses/delete_house.dart';
import 'package:hostmi/api/supabase/rest/houses/select_houses.dart';
import 'package:hostmi/api/utils/check_internet_status.dart';
import 'package:hostmi/ui/widgets/agency_house_card.dart';
import 'package:hostmi/ui/widgets/house_card_shimmer.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AgencyManagerPosts extends StatefulWidget {
  const AgencyManagerPosts({super.key, required this.agencyId});
  final String agencyId;

  @override
  State<AgencyManagerPosts> createState() => _AgencyManagerPostsState();
}

class _AgencyManagerPostsState extends State<AgencyManagerPosts> {
  final SizedBox _spacer = const SizedBox(
    height: 25,
  );

  late Future<List<HouseModel>> _future;

  @override
  void initState() {
    _future = getHouseList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.grey,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.publishedProperties,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: AppColor.black,
            ),
          ),
          FutureBuilder<List<HouseModel>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return SingleChildScrollView(
                      child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Column(
                        children: List.generate(
                          2,
                          (index) => const HouseCardShimmer(),
                          growable: false,
                        ).animate(
                          onComplete: (controller) {
                            controller.repeat();
                          },
                        ).shimmer(
                            blendMode: BlendMode.colorDodge,
                            duration: 1000.ms,
                            color: Colors.white54),
                      ),
                    )
                  ]));
                }

                if (snapshot.hasError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Error: ${snapshot.error}"),
                      IconButton(
                          onPressed: () {
                            _future = getHouseList();
                          },
                          icon: const Icon(
                            Icons.replay_circle_filled_rounded,
                            size: 40,
                            color: AppColor.primary,
                          ))
                    ],
                  );
                }
                if (!snapshot.hasData) {
                  return const Text("Error");
                }
                var data = snapshot.data;
                if (data!.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            _future = getHouseList();
                          },
                          icon: const Icon(
                            Icons.hide_image,
                            size: 40,
                            color: AppColor.primary,
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text("Aucun résultat.")
                    ],
                  ));
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _spacer,
                    // Text(
                    //   AppLocalizations.of(context)!.listMotivationalWord,
                    //   textAlign: TextAlign.center,
                    //   style: const TextStyle(
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                    SizedBox(
                        width: double.infinity,
                        child: Column(
                            children: data
                                .map((house) => AgencyHouseCard(
                                      house: house,
                                      onDelete: () async {
                                        bool hasInternet =
                                            await checkInternetStatus();
                                        if (hasInternet) {
                                          bool isDeleted =
                                              await deleteHouse(house.id!);
                                          if (isDeleted) {
                                            _future =
                                                getHouseList().whenComplete(() {
                                              setState(() {});
                                            });
                                          }
                                        }
                                      },
                                    ))
                                .toList()))
                  ],
                );
              })
          // AgencyHouseCard(
          //   house: HouseModel(),
          // ),
        ],
      ),
    );
  }

  Future<List<HouseModel>> getHouseList() async {
    final List<Map<String, dynamic>> housesList =
        await selectHousesByAgency(widget.agencyId);
    return housesList.map((e) => HouseModel.fromMap(e)).toList();
    // setState(() {});
  }
}
