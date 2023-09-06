import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hostmi/api/models/house_model.dart';
import 'package:hostmi/ui/pages/filter_page.dart';
import 'package:hostmi/ui/widgets/filter_button.dart';
import 'package:hostmi/ui/widgets/house_card.dart';
import 'package:hostmi/ui/widgets/rounded_text_field.dart';
import 'package:hostmi/utils/app_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final SizedBox _spacer = const SizedBox(height: 20);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      backgroundColor: AppColor.grey,
      body: SafeArea(
        child: Stack(
          children: [
            Scrollbar(
                child: SingleChildScrollView(
              child: Column(children: [
                const SizedBox(
                  height: 110,
                ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 25.0,
                          ),
                           Text(
                            AppLocalizations.of(context)!.listMotivationalWord,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          _spacer,
                          HouseCard(house: HouseModel()),
                          _spacer,
                          HouseCard(house: HouseModel()),
                          _spacer,
                        ],
                      ),
                    ),



              ]),
            )),
            Column(
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
                          ])
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RoundedTextField(
                        errorText: "Une erreur s'est produite",
                        placeholder: AppLocalizations.of(context)!.searchCityPlaceholder,
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
                      _spacer,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:  [
                          FilterButton(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                return const FilterPage();
                              }));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
