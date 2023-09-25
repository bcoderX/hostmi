import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/ui/screens/add_house1.dart';
import 'package:hostmi/ui/widgets/house_card.dart';
import 'package:hostmi/ui/widgets/landloard_action_button.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LandlordPage extends StatefulWidget {
  const LandlordPage({Key? key}) : super(key: key);

  @override
  State<LandlordPage> createState() => _LandlordPageState();
}

class _LandlordPageState extends State<LandlordPage> {
  final SizedBox _spacer = const SizedBox(height: 10);
  @override
  Widget build(BuildContext context) {
    //Size _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.grey,
        foregroundColor: AppColor.black,
        elevation: 0.0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
        title: const Text(
          "Hostmi",
          style: TextStyle(color: AppColor.black),
        ),
        actions: [
          InkWell(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.edit,
                  color: AppColor.primary,
                  size: 30,
                ),
                Text(
                  AppLocalizations.of(context)!.edit,
                  style: const TextStyle(color: AppColor.black, fontSize: 18.0),
                ),
                const SizedBox(
                  width: 5.0,
                )
              ],
            ),
            onTap: () {},
          )
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          color: Colors.deepOrange,
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/1.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple,
                              offset: Offset(0, 16.0),
                              blurRadius: 30.0,
                              spreadRadius: 10.0,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 65.0),
                    ],
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 130,
                        width: 170,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/2.jpg"),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 25),
                width: double.maxFinite,
                height: 60,
                decoration: const BoxDecoration(
                    color: AppColor.grey,
                    border: Border.symmetric(
                        horizontal: BorderSide(color: AppColor.grey))),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LandlordActionButton(
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.grey[800],
                          size: 18.0,
                        ),
                        text: AppLocalizations.of(context)!.addHouse,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return const AddHouse1();
                          }));
                        },
                      ),
                      LandlordActionButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.grey[800],
                          size: 18.0,
                        ),
                        text: AppLocalizations.of(context)!.manage,
                      ),
                      LandlordActionButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.grey[800],
                          size: 18.0,
                        ),
                        text: AppLocalizations.of(context)!.share,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4.0),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 7.0,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 10.0),
                      child: Text(
                        AppLocalizations.of(context)!.details,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: AppColor.black,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _spacer,
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: AppColor.primary,
                              ),
                              Text(
                                "${AppLocalizations.of(context)!.name} : Hostmi",
                                style: const TextStyle(
                                  color: AppColor.black,
                                ),
                              ),
                            ],
                          ),
                          _spacer,
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: AppColor.primary,
                              ),
                              Text(
                                "${AppLocalizations.of(context)!.phone} : +22664260325",
                                style: const TextStyle(
                                  color: AppColor.black,
                                ),
                              ),
                            ],
                          ),
                          _spacer,
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
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
                    _spacer,
                    HouseCard(
                      house: HouseModel(),
                    ),
                    _spacer,
                    HouseCard(
                      house: HouseModel(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
