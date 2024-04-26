import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/supabase/rest/houses/select_houses.dart';
import 'package:hostmi/ui/widgets/house_card.dart';
import 'package:hostmi/ui/widgets/house_card_shimmer.dart';
import 'package:hostmi/utils/app_color.dart';

class AgencyPosts extends StatefulWidget {
  const AgencyPosts({super.key, required this.agencyId});
  final String agencyId;

  @override
  State<AgencyPosts> createState() => _AgencyPostsState();
}

class _AgencyPostsState extends State<AgencyPosts> {
  final SizedBox _spacer = const SizedBox(
    height: 25,
  );

  final int _selectedIndex = 0;

  int page = 1;

  late Future<List<HouseModel>> _future;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    _future = getHouseList(page, _selectedIndex);
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        setState(() {
          _future = getHouseList(page, _selectedIndex);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HouseModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(
                top: 25.0,
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
            ));
          }

          if (snapshot.hasError) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text("Error: ${snapshot.error}"),
                IconButton(
                    onPressed: () {
                      _future = getHouseList(page, _selectedIndex);
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
          var data = snapshot.data;
          if (data!.isEmpty) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      _future = getHouseList(page, _selectedIndex);
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

          return Scrollbar(
              controller: _controller,
              child: SingleChildScrollView(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: Column(
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
                                    .map((house) => HouseCard(
                                          house: house,
                                        ))
                                    .toList()))
                      ],
                    ),
                  ),
                ]),
              ));
        });
  }

  Future<List<HouseModel>> getHouseList(int page, int type) async {
    final List<Map<String, dynamic>> housesList =
        await selectHousesByAgencyForUsers(widget.agencyId);
    return housesList.map((e) => HouseModel.fromMap(e)).toList();
    // setState(() {});
  }
}
