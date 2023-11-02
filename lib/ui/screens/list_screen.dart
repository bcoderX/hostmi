import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/api/supabase/houses/select_houses.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/screens/ball_loading_page.dart';
import 'package:hostmi/ui/screens/filter_page.dart';
import 'package:hostmi/ui/widgets/filter_button.dart';
import 'package:hostmi/ui/widgets/house_card.dart';
import 'package:hostmi/ui/widgets/landloard_action_button.dart';
import 'package:hostmi/ui/widgets/rounded_text_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final SizedBox _spacer = SizedBox(height: getVerticalSize(20));
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;
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
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<HostmiProvider>().getHouseTypes();
    });

    return Scaffold(
        backgroundColor: AppColor.grey,
        body: SafeArea(
          child: Stack(
            children: [
              FutureBuilder<List<HouseModel>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const BallLoadingPage();
                    }

                    if (snapshot.hasError) {
                      return Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Error: ${snapshot.error}"),
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
                            const SizedBox(
                              height: 120,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 60.0,
                                  ),
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
                  }),
              SizedBox(
                child: Container(
                  color: AppColor.grey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 30,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              AppColor.grey,
                              AppColor.grey.withOpacity(.3),
                              AppColor.grey.withOpacity(0),
                            ])),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: RoundedTextField(
                              errorText: "Une erreur s'est produite",
                              placeholder: AppLocalizations.of(context)!
                                  .searchCityPlaceholder,
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: Align(
                                  widthFactor: double.minPositive,
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 25.0,
                                    ),
                                    child: RichText(
                                      text: const TextSpan(
                                        style: TextStyle(
                                          color: AppColor.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(text: "Host"),
                                          TextSpan(
                                            text: "MI",
                                            style: TextStyle(
                                              color: AppColor.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                          _spacer,
                          const SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Choisir le type de maison",
                                style: TextStyle(
                                    color: AppColor.listItemGrey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ActionButton(
                                  padding: getPadding(
                                    left: 12,
                                    top: 12,
                                    right: 12,
                                    bottom: 12,
                                  ),
                                  icon:
                                      null /* Icon(
                                      Icons.pages,
                                      color: _selectedIndex == 0
                                          ? AppColor.white
                                          : Colors.grey[800],
                                      size: 18.0,
                                    ) */
                                  ,
                                  text: "Tout",
                                  backgroundColor: _selectedIndex == 0
                                      ? AppColor.primary
                                      : null,
                                  foregroundColor: _selectedIndex == 0
                                      ? AppColor.white
                                      : null,
                                  onPressed: () {
                                    setSelectedIndex(0);
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //     builder: (BuildContext context) {
                                    //   return const AddHouse1();
                                    // }));
                                  },
                                ),
                                ...context
                                    .watch<HostmiProvider>()
                                    .houseTypesList
                                    .map(
                                      (houseType) => ActionButton(
                                        padding: getPadding(
                                          left: 12,
                                          top: 12,
                                          right: 12,
                                          bottom: 12,
                                        ),
                                        icon:
                                            null /* Icon(
                                      Icons.pages,
                                      color: _selectedIndex == 0
                                          ? AppColor.white
                                          : Colors.grey[800],
                                      size: 18.0,
                                    ) */
                                        ,
                                        text: houseType["fr"],
                                        backgroundColor:
                                            _selectedIndex == houseType["id"]
                                                ? AppColor.primary
                                                : null,
                                        foregroundColor:
                                            _selectedIndex == houseType["id"]
                                                ? AppColor.white
                                                : null,
                                        onPressed: () {
                                          setSelectedIndex(houseType["id"]);
                                          // Navigator.of(context).push(MaterialPageRoute(
                                          //     builder: (BuildContext context) {
                                          //   return const AddHouse1();
                                          // }));
                                        },
                                      ),
                                    )
                                    .toList(),
                                ActionButton(
                                  padding: getPadding(
                                    left: 12,
                                    top: 12,
                                    right: 12,
                                    bottom: 12,
                                  ),
                                  icon: null,
                                  /* Icon(
                                      Icons.pages,
                                      color: _selectedIndex == 0
                                          ? AppColor.white
                                          : Colors.grey[800],
                                      size: 18.0,
                                    ) */

                                  text: "Plus de filtres",
                                  backgroundColor: _selectedIndex == -1
                                      ? AppColor.primary
                                      : null,
                                  foregroundColor: _selectedIndex == -1
                                      ? AppColor.white
                                      : null,
                                  onPressed: () {
                                    setSelectedIndex(-1);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                      return const FilterPage();
                                    }));
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5)
                          /*  Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FilterButton(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) {
                                  return const FilterPage();
                                }));
                              },
                            ),
                          ],
                        ),
                      */
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _future = getHouseList(page, _selectedIndex);
          },
          tooltip: "Trier",
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text("Trier")],
          ),
        ));
  }

  Future<List<HouseModel>> getHouseList(int page, int type) async {
    final List<Map<String, dynamic>> housesList =
        type == 0 ? await selectHouses() : await selectHousesByType(type);
    return housesList.map((e) => HouseModel.fromMap(e)).toList();
    // setState(() {});
  }

  void setSelectedIndex(int i) => setState(() {
        _selectedIndex = i;
        _future = getHouseList(page, i);
      });
}
