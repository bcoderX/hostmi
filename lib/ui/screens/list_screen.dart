import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/api/providers/hostmi_provider.dart';
import 'package:hostmi/core/app_export.dart';
import 'package:hostmi/ui/screens/filter_page.dart';
import 'package:hostmi/ui/widgets/filter_button.dart';
import 'package:hostmi/ui/widgets/house_card.dart';
import 'package:hostmi/ui/widgets/landloard_action_button.dart';
import 'package:hostmi/ui/widgets/rounded_text_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final SizedBox _spacer = const SizedBox(height: 20);
  int _selectedIndex = 0;
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
              Scrollbar(
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
                          child: Wrap(
                            spacing: 20,
                            runAlignment: WrapAlignment.center,
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _spacer,
                              HouseCard(house: HouseModel()),
                              _spacer,
                              HouseCard(house: HouseModel()),
                              _spacer,
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ]),
              )),
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
                              horizontal: 20.0,
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
                          Scrollbar(
                            scrollbarOrientation: ScrollbarOrientation.right,
                            child: SingleChildScrollView(
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
          onPressed: () {},
          tooltip: "Trier",
          child: const Icon(Icons.sort),
        ));
  }

  void setSelectedIndex(int i) => setState(() {
        _selectedIndex = i;
      });
}
